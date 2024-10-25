{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "puncia";
  version = "0.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ARPSyndicate";
    repo = "puncia";
    rev = "refs/tags/v${version}";
    hash = "sha256-4PJyAYPRsqay5Y9RxhOpUgIJvntVKokqYhE1b+hVc44=";
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
