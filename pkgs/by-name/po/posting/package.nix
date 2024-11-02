{
  lib,
  fetchFromGitHub,
  python3,
}:
let
  py-pkgs = python.pkgs;
  python = python3.override {
    packageOverrides = self: super: {
      # Current nixpkgs version is too outdated, causes crash on startup
      pydantic-settings = (
        super.pydantic-settings.overrideAttrs (oldAttrs: rec {
          version = "2.6.0";
          src = fetchFromGitHub {
            owner = "pydantic";
            repo = "pydantic-settings";
            rev = "refs/tags/v${version}";
            hash = "sha256-gJThzYJg6OIkfmfi/4MVINsrvmg+Z+0xMhdlCj7Fn+w=";
          };
          propagatedBuildInputs = [
            super.pydantic
            super.python-dotenv
          ];
        })
      );

      # Current nixpkgs version is too outdated, posting maintainer explicitly warns against relaxing this dependency
      textual = (
        super.textual.overrideAttrs (oldAttrs: rec {
          version = "0.85.0";
          src = fetchFromGitHub {
            owner = "Textualize";
            repo = "textual";
            rev = "refs/tags/v${version}";
            hash = "sha256-ROq/Pjq6XRgi9iqMlCzpLmgzJzLl21MI7148cOxHS3o=";
          };
        })
      );
    };
  };
in
py-pkgs.buildPythonApplication rec {
  pname = "posting";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "posting";
    rev = "refs/tags/${version}";
    sha256 = "sha256-6KtC5VuG3x07VTenpyDAJr9KO4jdTCFk1u/pSoyYPsc=";
  };

  patches = [ ./relax-pyproject.patch ];

  nativeBuildInputs = [ py-pkgs.hatchling ];

  propagatedBuildInputs = [
    py-pkgs.click
    py-pkgs.xdg-base-dirs
    py-pkgs.click-default-group
    py-pkgs.pyperclip
    py-pkgs.pyyaml
    py-pkgs.python-dotenv
    py-pkgs.watchfiles
    py-pkgs.pydantic
    py-pkgs.pydantic-settings
    py-pkgs.httpx
    py-pkgs.textual
    py-pkgs.textual-autocomplete
  ];

  meta = {
    description = "The modern API client that lives in your terminal.";
    mainProgram = "posting";
    homepage = "https://posting.sh/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jorikvanveen ];
    platforms = lib.platforms.unix;
  };
}
