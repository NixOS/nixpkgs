{
  lib,
  python3,
  fetchFromGitHub,
  ffmpeg,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "lue";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "paulilaaso";
    repo = "lue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tscMjgJ1YxJ96BMGbxlsa12bXJtFRTAjyxsFuvNkzYI=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    edge-tts
    markdown
    platformdirs
    pymupdf
    python-docx
    rich
    striprtf
  ];

  optional-dependencies = with python3.pkgs; {
    kokoro = [
      huggingface-hub
      kokoro
      soundfile
    ];
  };

  pythonImportsCheck = [ "lue" ];

  makeWrapperArgs = [ "--prefix PATH :${lib.makeBinPath [ ffmpeg ]}" ];

  meta = {
    description = "Terminal eBook Reader with Text-to-Speech";
    homepage = "https://github.com/paulilaaso/lue";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "lue";
  };
})
