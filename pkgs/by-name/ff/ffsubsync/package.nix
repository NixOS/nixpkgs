{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ffsubsync";
  version = "0.4.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "smacke";
    repo = "ffsubsync";
    rev = "refs/tags/${version}";
    hash = "sha256-ZdKZeKfAUe/FXLOur9Btb5RgXewmy3EHunQphqlxpIc=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
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

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ffsubsync"
  ];

  meta = with lib; {
    homepage = "https://github.com/smacke/ffsubsync";
    description = "Automagically synchronize subtitles with video";
    license = licenses.mit;
    maintainers = with maintainers; [ Benjamin-L ];
    mainProgram = "ffsubsync";
  };
}
