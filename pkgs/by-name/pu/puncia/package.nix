{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "puncia";
  version = "0.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ARPSyndicate";
    repo = "puncia";
    tag = "v${version}";
    hash = "sha256-P3F3e53H37Wr2qCRiEaQQ6SQBrSNILk+wT3Q9DIh0FU=";
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
