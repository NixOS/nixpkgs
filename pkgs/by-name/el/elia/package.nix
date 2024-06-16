{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "elia";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "elia";
    rev = "refs/tags/${version}";
    hash = "sha256-hQe/0M58JfSC7t0hPVsN0rNeHQh1LUccj/CxR+1RbEw=";
  };

  build-system = [ python3.pkgs.hatchling ];

  dependencies = with python3.pkgs; [
    aiosqlite
    click
    click-default-group
    google-generativeai
    greenlet
    humanize
    litellm
    pyperclip
    sqlmodel
    textual
    xdg-base-dirs
  ];

  pythonImportsCheck = [ "elia_chat" ];

  meta = with lib; {
    description = "A snappy, keyboard-centric terminal user interface for interacting with large language models";
    homepage = "https://github.com/darrenburns/elia";
    changelog = "https://github.com/darrenburns/elia/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "elia";
  };
}
