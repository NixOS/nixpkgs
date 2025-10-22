{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "linstor-client";
  version = "1.26.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LINBIT";
    repo = "linstor-client";
    tag = "v${version}";
    hash = "sha256-QEP3YLmBwvNvUcU/OLPgkb2O9tguOngYVj0HRhIGd0A=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = [
    python3.pkgs.linstor-api-py
  ];

  pythonImportsCheck = [
    "linstor_client"
  ];

  meta = {
    description = "Python client for LINSTOR";
    homepage = "https://github.com/LINBIT/linstor-client";
    changelog = "https://github.com/LINBIT/linstor-client/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    mainProgram = "linstor-client";
  };
}
