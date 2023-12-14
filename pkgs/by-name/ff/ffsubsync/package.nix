{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "ffsubsync";
  version = "0.4.25";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "smacke";
    repo = "ffsubsync";
    rev = version;
    hash = "sha256-ZdKZeKfAUe/FXLOur9Btb5RgXewmy3EHunQphqlxpIc=";
  };

  propagatedBuildInputs = with python3Packages; [
    auditok
    charset-normalizer
    faust-cchardet
    ffmpeg-python
    future
    numpy
    pysubs2
    chardet
    rich
    six
    srt
    tqdm
    typing-extensions
    webrtcvad
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "ffsubsync" ];

  meta = with lib; {
    homepage = "https://github.com/smacke/ffsubsync";
    description = "Automagically synchronize subtitles with video";
    license = licenses.mit;
    maintainers = with maintainers; [ Benjamin-L ];
    mainProgram = "ffsubsync";
  };
}
