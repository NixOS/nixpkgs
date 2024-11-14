{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3,
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

  patches = [
    # updates for python 3.12 (not currently included in a release)
    (fetchpatch {
      url = "https://github.com/smacke/ffsubsync/commit/de75bdbfe846b3376f8c0bcfe2e5e5db82d7ff20.patch";
      hash = "sha256-JN7F9H9G8HK2aLOlm/Ec+GsWnU+65f1P658nq8FbAjo=";
    })
  ];

  nativeBuildInputs = with python3.pkgs; [ setuptools ];

  propagatedBuildInputs = with python3.pkgs; [
    auditok
    charset-normalizer
    faust-cchardet
    ffmpeg-python
    future
    numpy
    pkgs.ffmpeg
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

  meta = with lib; {
    homepage = "https://github.com/smacke/ffsubsync";
    description = "Automagically synchronize subtitles with video";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "ffsubsync";
  };
}
