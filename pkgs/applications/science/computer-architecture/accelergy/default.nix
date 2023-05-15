{ lib, fetchFromGitHub, python3Packages, pkgs }:

python3Packages.buildPythonApplication rec {
  pname = "accelergy";
  version = "unstable-2022-05-03";

  src = fetchFromGitHub {
    owner = "Accelergy-Project";
    repo = "accelergy";
    rev = "34df8e87a889ae55cecba58992d4573466b40565";
    hash = "sha256-SRtt1EocHy5fKszpoumC+mOK/qhreoA2/Ff1wcu5WKo=";
  };

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    yamlordereddictloader
    pyfiglet
    setuptools
  ];

  meta = with lib; {
    description = "An architecture-level energy/area estimator for accelerator designs";
    license = licenses.mit;
    homepage = "https://accelergy.mit.edu/";
    maintainers = with maintainers; [ gdinh ];
  };
}
