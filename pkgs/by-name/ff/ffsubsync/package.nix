{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ffsubsync";
  version = "0.4.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "smacke";
    repo = "ffsubsync";
    tag = finalAttrs.version;
    hash = "sha256-j9E4h2de2EOtYpuxKFbPOxZ5FBRO0EkbZhJdx5RiPn8=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
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

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ffsubsync"
  ];

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
})
