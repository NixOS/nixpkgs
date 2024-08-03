{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "elia";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "elia";
    rev = "refs/tags/${version}";
    hash = "sha256-n8bw/j+hVvniR2zefgdeYv3VWDZl5my1IRcskDu5fBE=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies =
    (with python3Packages; [
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
    ])
    ++ [
    # Pin until upstream updates this dependency
      (python3Packages.textual.overrideAttrs (finalAttrs: {
        version = "0.62.0";
        src = fetchFromGitHub {
          owner = "Textualize";
          repo = "textual";
          rev = "v${finalAttrs.version}";
          hash = "sha256-3zMA2gZMvXTDOPVyMf/i4onumkHL85om1rvfnBN4VEE=";
        };
      }))
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
