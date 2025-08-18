{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lue";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "superstarryeyes";
    repo = "lue";
    tag = "v${version}";
    hash = "sha256-YricCgY/Zi14Xh1fiNrLKy+Cn/R1gO3wnvnqVK75Ths=";
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

  meta = {
    description = "Terminal eBook Reader with Text-to-Speech";
    homepage = "https://github.com/superstarryeyes/lue";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "lue";
  };
}
