{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "puncia";
  version = "0.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ARPSyndicate";
    repo = "puncia";
    tag = "v${version}";
    hash = "sha256-+RA7vAp2bjyZYIe0oyDeTQx89Gl3UEP4D3uSNVlF3i0=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "puncia" ];

  meta = with lib; {
    description = "CLI utility for Subdomain Center & Exploit Observer";
    homepage = "https://github.com/ARPSyndicate/puncia";
    changelog = "https://github.com/ARPSyndicate/puncia/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "puncia";
  };
}
