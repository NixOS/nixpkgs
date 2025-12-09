{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "lexy";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "antoniorodr";
    repo = "lexy";
    tag = "v${version}";
    hash = "sha256-r6Jy37Ici7l0jlQiGdF0YlbViW0Tl+0UwHMAe59YoKc=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    click
    requests
    typer
    tomlkit
  ];

  optional-dependencies = with python3Packages; {
    docs = [
      mkdocs
      mkdocs-awesome-nav
      mkdocs-material
    ];
  };

  pythonImportsCheck = [
    "lexy"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight CLI tool that fetches programming tutorials from \"Learn X in Y Minutes\" directly into your terminal";
    homepage = "https://github.com/antoniorodr/lexy.git";
    changelog = "https://github.com/antoniorodr/lexy/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puiyq ];
    mainProgram = "lexy";
  };
}
