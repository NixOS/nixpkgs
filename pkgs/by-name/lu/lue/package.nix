{
  lib,
  python3,
  fetchFromGitHub,
  ffmpeg,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lue";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "superstarryeyes";
    repo = "lue";
    tag = "v${version}";
    hash = "sha256-D1y7nu3WIsnShy2ruyF06iVusD8leuaAUi0M8I1hVqQ=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal eBook Reader with Text-to-Speech";
    homepage = "https://github.com/superstarryeyes/lue";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "lue";
  };
}
