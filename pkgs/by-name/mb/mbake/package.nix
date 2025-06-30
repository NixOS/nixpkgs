{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "mbake";
  version = "1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EbodShojaei";
    repo = "bake";
    tag = "v${version}";
    hash = "sha256-RzM3HC3lYq93mngpqNCohcPMISWQ4+Lwa1V88S0O0To=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    rich
    typer
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  pythonImportsCheck = [ "bake" ];

  meta = {
    description = "Makefile formatter and linter";
    homepage = "https://github.com/EbodShojaei/bake";
    changelog = "https://github.com/EbodShojaei/bake/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "mbake";
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
