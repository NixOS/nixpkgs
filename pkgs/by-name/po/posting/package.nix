{
  lib,
  fetchFromGitHub,
  python3Packages,
  xrdb,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "posting";
  version = "2.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "posting";
    tag = finalAttrs.version;
    hash = "sha256-BX1D9XgBqRIfavDxAQH7mPP/dnayQu3xSSAF6/JSM54=";
  };

  pythonRelaxDeps = true;

  build-system = with python3Packages; [
    hatchling
  ];

  # Required for x resources themes
  buildInputs = [
    xrdb
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
    changelog = "https://github.com/darrenburns/posting/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jorikvanveen
      fullmetalsheep
    ];
    platforms = lib.platforms.unix;
  };
})
