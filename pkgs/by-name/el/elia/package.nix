{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "elia";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "elia";
    rev = "refs/tags/${version}";
    hash = "sha256-tf5FU1k140g84/BxruFXQS2h3kL1hSCvDv9kljPI410=";
  };

  pythonRelaxDeps = [
    "textual"
  ];

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    aiosqlite
    click
    click-default-group
    google-generativeai
    greenlet
    humanize
    litellm
    pyperclip
    sqlmodel
    xdg-base-dirs
    textual
  ];

  pythonImportsCheck = [ "elia_chat" ];

  meta = with lib; {
    description = "Snappy, keyboard-centric terminal user interface for interacting with large language models";
    homepage = "https://github.com/darrenburns/elia";
    changelog = "https://github.com/darrenburns/elia/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "elia";
  };
}
