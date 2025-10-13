{
  lib,
  fetchFromGitHub,
  python3Packages,
  xorg,
}:
python3Packages.buildPythonApplication rec {
  pname = "posting";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "posting";
    tag = version;
    hash = "sha256-JkYcLh3S+vLfSCgIpiRu9tKPMjjDSdHtO8faeMlgbe8=";
  };

  pythonRelaxDeps = true;

  build-system = with python3Packages; [
    hatchling
  ];

  # Required for x resources themes
  buildInputs = [
    xorg.xrdb
  ];

  dependencies =
    with python3Packages;
    [
      click
      xdg-base-dirs
      click-default-group
      pyperclip
      pyyaml
      python-dotenv
      watchfiles
      pydantic
      pydantic-settings
      httpx
      textual-autocomplete
      textual
      openapi-pydantic
      tree-sitter-json
      tree-sitter-html
    ]
    ++ httpx.optional-dependencies.brotli
    ++ textual.optional-dependencies.syntax;

  meta = {
    description = "Modern API client that lives in your terminal";
    mainProgram = "posting";
    homepage = "https://posting.sh/";
    changelog = "https://github.com/darrenburns/posting/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jorikvanveen
      fullmetalsheep
    ];
    platforms = lib.platforms.unix;
  };
}
