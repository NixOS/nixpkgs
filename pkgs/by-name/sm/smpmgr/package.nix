{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "smpmgr";
  version = "0.18.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intercreate";
    repo = "smpmgr";
    tag = finalAttrs.version;
    hash = "sha256-Kcd6D995bS9GbytkTPam0KKuqNjuajMjDMfKx7TWm20=";
  };

  build-system = with python3Packages; [
    poetry-core
    poetry-dynamic-versioning
  ];

  pythonRelaxDeps = [
    "typer"
    "smpclient"
  ];

  dependencies =
    with python3Packages;
    [
      readchar
      smpclient
      typer
    ]
    ++ smpclient.optional-dependencies.all;

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "smpmgr" ];

  meta = {
    description = "Simple Management Protocol (SMP) Manager for remotely managing MCU firmware";
    homepage = "https://github.com/intercreate/smpmgr";
    changelog = "https://github.com/intercreate/smpmgr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "smpmgr";
  };
})
