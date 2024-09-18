{ lib
, fetchFromGitHub
, python3
, ffmpeg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pianotrans";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "azuwis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gRbyUQmPtGvx5QKAyrmeJl0stp7hwLBWwjSbJajihdE=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    piano-transcription-inference
    resampy
    tkinter
    torch
  ];

  # Project has no tests
  doCheck = false;

  makeWrapperArgs = [
    ''--prefix PATH : "${lib.makeBinPath [ ffmpeg ]}"''
  ];

  meta = with lib; {
    description = "Simple GUI for ByteDance's Piano Transcription with Pedals";
    mainProgram = "pianotrans";
    homepage = "https://github.com/azuwis/pianotrans";
    license = licenses.mit;
    maintainers = with maintainers; [ azuwis ];
  };
}
