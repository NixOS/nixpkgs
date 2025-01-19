{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
let
in
python3Packages.buildPythonApplication rec {
  pname = "posting";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "posting";
    rev = "refs/tags/${version}";
    sha256 = "sha256-lL85gJxFw8/e8Js+UCE9VxBMcmWRUkHh8Cq5wTC93KA=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = [ python3Packages.hatchling ];

  dependencies =
    [
      python3Packages.click
      python3Packages.xdg-base-dirs
      python3Packages.click-default-group
      python3Packages.pyperclip
      python3Packages.pyyaml
      python3Packages.python-dotenv
      python3Packages.watchfiles
      python3Packages.pydantic
      python3Packages.pydantic-settings
      python3Packages.httpx
      python3Packages.textual-autocomplete
      python3Packages.textual
    ]
    ++ python3Packages.httpx.optional-dependencies.brotli
    ++ python3Packages.textual.optional-dependencies.syntax;

  meta = {
    description = "Modern API client that lives in your terminal";
    mainProgram = "posting";
    homepage = "https://posting.sh/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jorikvanveen ];
    platforms = lib.platforms.unix;
  };
}
