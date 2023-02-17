{ lib
, fetchFromGitHub
, python3
, ffmpeg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pianotrans";
  version = "1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "azuwis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6Otup1Yat1dBZdSoR4lDfpytUQ2RbDXC6ieo835Nw+U=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    piano-transcription-inference
    torch
    tkinter
  ];

  # Project has no tests
  doCheck = false;

  makeWrapperArgs = [
    ''--prefix PATH : "${lib.makeBinPath [ ffmpeg ]}"''
  ];

  meta = with lib; {
    description = "Simple GUI for ByteDance's Piano Transcription with Pedals";
    homepage = "https://github.com/azuwis/pianotrans";
    license = licenses.mit;
    maintainers = with maintainers; [ azuwis ];
  };
}
