{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "posting";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "posting";
    rev = "refs/tags/${version}";
    hash = "sha256-g8SlW7YLz/H5euZZIaNbB+mUqM630HSzVHUoIIZI/1g=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies =
    with python3Packages;
    [
      click
      click-default-group
      httpx
      pydantic
      pydantic-settings
      pyperclip
      python-dotenv
      pyyaml
      textual
      textual-autocomplete
      xdg-base-dirs
    ]
    ++ httpx.optional-dependencies.brotli
    ++ textual.optional-dependencies.syntax;

  pythonRelaxDeps = true;

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = "export HOME=$(mktemp -d)";

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    textual-dev
    jinja2
    syrupy
    pytest-xdist
    pytest-cov
    pytest-textual-snapshot
  ];

  pythonImportsCheck = [ "posting" ];

  meta = {
    description = "Modern API client that lives in your terminal";
    homepage = "https://github.com/darrenburns/posting";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ taha-yassine ];
    mainProgram = "posting";
  };
}
