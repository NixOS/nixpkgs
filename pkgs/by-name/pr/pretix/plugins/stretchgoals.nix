{ lib
, buildPythonPackage
, fetchFromGitHub
, pretix-plugin-build
, setuptools
}:

buildPythonPackage {
  pname = "pretix-avgchart";
  version = "unstable-2023-11-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rixx";
    repo = "pretix-avgchart";
    rev = "219816c7ec523a5c23778523b2616ac0c835cb3a";
    hash = "sha256-1V/0PUvStgQeBQ0v6GoofAgyPmWs3RD+v5ekmAO9vFU=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "pretix_stretchgoals"
  ];

  meta = with lib; {
    description = "Display the average ticket sales price over time";
    homepage = "https://github.com/rixx/pretix-avgchart";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
