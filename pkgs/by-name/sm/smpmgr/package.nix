{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smpmgr";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intercreate";
    repo = "smpmgr";
    rev = version;
    hash = "sha256-MFrM2ckTIngnXcIp8hFDc6ikjHa81mDsYA1t3KWrxdc=";
  };

  build-system = [
    python3.pkgs.poetry-core
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    readchar
    smpclient
    typer
  ];

  pythonImportsCheck = [
    "smpmgr"
  ];

  meta = {
    description = "Simple Management Protocol (SMP) Manager for remotely managing MCU firmware";
    homepage = "https://github.com/intercreate/smpmgr";
    changelog = "https://github.com/intercreate/smpmgr/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "smpmgr";
  };
}
