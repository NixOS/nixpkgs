{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "puncia";
  version = "0.15-unstable-2024-03-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ARPSyndicate";
    repo = "puncia";
    # https://github.com/ARPSyndicate/puncia/issues/5
    rev = "c70ed93ea1e7e42e12dd9c14713cab71bb0e0fe9";
    hash = "sha256-xGJk8y26tluHUPm9ikrBBiWGuzq6MKl778BF8wNDmps=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "puncia"
  ];

  meta = with lib; {
    description = "CLI utility for Subdomain Center & Exploit Observer";
    homepage = "https://github.com/ARPSyndicate/puncia";
    # https://github.com/ARPSyndicate/puncia/issues/6
    license = licenses.unfree;
    maintainers = with maintainers; [ fab ];
    mainProgram = "puncia";
  };
}
