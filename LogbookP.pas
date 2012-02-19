// =============================================================================
// =============================================================================
unit LogbookP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, jpeg, ImgList, ToolWin;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    StatusBar: TStatusBar;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure SaveAsButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Save;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//==============================================================================
function LoadFromFile(filename: string): string;
var
  ch: char;
  s: string;
  ms: TMemoryStream;
begin
  if fileExists(filename) then begin
    ms := TMemoryStream.Create;
    s := '';
    ms.LoadFromFile(filename);
    try
      while(ms.Position < ms.Size) do begin
        ms.Read(ch, 1);
        s := s + ch;
      end;
    finally
      ms.Free;
    end;
  end;
  result := s;
end;
// =============================================================================
function SaveToFile(instr, filename: string): boolean;
var
  i: integer;
  ch: char;
  ms: TMemoryStream;
  s1: string;
begin
  result := false;
  if(filename <> '') then begin
    ms := TMemoryStream.Create;
    try
      for i := 1 to length(instr) do begin
        ch := instr[i];
        ms.Write(ch, 1);
      end;
      ms.SaveToFile(filename);
    finally
      ms.Free;
      result := true;
    end;
  end;
end;
//==============================================================================
procedure TForm1.FormCreate(Sender: TObject);
var
  s: string;
begin
  s := ExtractFilePath(Application.ExeName) + 'LastLogfile.txt';
  if fileExists(s) then begin
    OpenDialog1.FileName := LoadFromFile(s);
    SaveDialog1.FileName := OpenDialog1.FileName;
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
    Form1.Caption := 'Logbook: ' + OpenDialog1.FileName;
  end else Memo1.Clear;

  OpenDialog1.Filter := 'Log files (*.txt)|*.TXT|All files (*.*)|*.*';
  SaveDialog1.Filter := 'Log files (*.txt)|*.TXT|All files (*.*)|*.*';
end;
// =============================================================================
procedure TForm1.FormResize(Sender: TObject);
begin
  StatusBar.Panels[0].Width := Form1.ClientWidth div 4;
  StatusBar.Panels[1].Width := StatusBar.Panels[0].Width;
  StatusBar.Panels[2].Width := StatusBar.Panels[0].Width;
  StatusBar.Panels[3].Width := StatusBar.Panels[0].Width;
end;
// =============================================================================
procedure TForm1.SaveButtonClick(Sender: TObject);
begin
  Save;
end;
// =============================================================================
procedure TForm1.SaveAsButtonClick(Sender: TObject);
begin
  if SaveDialog1.Execute then Save;
end;
// =============================================================================
procedure TForm1.Save;
var
  s: string;
begin
  s := ExtractFilePath(Application.ExeName) + 'LastLogfile.txt';
  SaveToFile(Memo1.Text, SaveDialog1.FileName);
  SaveToFile(SaveDialog1.FileName, s);
end;
// =============================================================================
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Save;
end;
// =============================================================================
procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    Form1.Caption := 'Logbook: ' + OpenDialog1.FileName;
    SaveDialog1.FileName := OpenDialog1.FileName;
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
  end;
end;
// =============================================================================
procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  Save;
end;
// =============================================================================
procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  if SaveDialog1.Execute then Save;
end;
// =============================================================================
end.
// =============================================================================
