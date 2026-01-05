{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "smpmgr";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intercreate";
    repo = "smpmgr";
    tag = version;
    hash = "sha256-ZIIHxQLBwd5OAxFqg0iOrdC7Xu3oZPHSJjdpo2CidAg=";
  };

  build-system = with python3Packages; [
    poetry-core
    poetry-dynamic-versioning
  ];

  pythonRelaxDeps = [
    "typer"
    "smpclient"
  ];

  dependencies = with python3Packages; [
    readchar
    smpclient
    typer
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  pythonImportsCheck = [ "smpmgr" ];

  meta = {
    description = "Simple Management Protocol (SMP) Manager for remotely managing MCU firmware";
    homepage = "https://github.com/intercreate/smpmgr";
    changelog = "https://github.com/intercreate/smpmgr/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "smpmgr";
  };
}
