{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "smpmgr";
<<<<<<< HEAD
  version = "0.16.0";
=======
  version = "0.15.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intercreate";
    repo = "smpmgr";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-woQ8NxHZ9lYKvEFjGbvBu7/949bzAV6hs9t/3+N7bJc=";
=======
    hash = "sha256-ZIIHxQLBwd5OAxFqg0iOrdC7Xu3oZPHSJjdpo2CidAg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
