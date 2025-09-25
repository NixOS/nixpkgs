{
  lib,
  python3,
  fetchFromGitHub,
  ffmpeg,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ffsubsync";
  version = "0.4.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "smacke";
    repo = "ffsubsync";
    tag = version;
    hash = "sha256-Px4WaeFn6SS6VUsm0bAKmdVtqQzXX12PRKO1n6UNxdM=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    auditok
    charset-normalizer
    faust-cchardet
    ffmpeg-python
    numpy
    pysubs2
    chardet
    rich
    setuptools
    six
    srt
    tqdm
    typing-extensions
    webrtcvad
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "ffsubsync" ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${ffmpeg}/bin"
  ];

  meta = {
    homepage = "https://github.com/smacke/ffsubsync";
    description = "Automagically synchronize subtitles with video";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ffsubsync";
  };
}
