{ pkgs 
, lib ? lib
, stdenv ? stdenv
, fetchFromGitHub ? fetchFromGitHub
, python3Packages ? pkgs.python3Packages
}:

python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "96ee992e5f2cc95672964d7f5a55168549e501d4";
    sha256 = "0p11b039vfn9696zrnl1hl6hrm60mpkhg76jrwk57rg29vy1lcfv";
  };
  nativeBuildInputs = [
    python3Packages.hatchling
  ];

  propagatedBuildInputs = with python3Packages; [
    gitpython
    psutil
    requests
  ];

  meta = with lib; {
      homepage = "https://openmesh.network/";
      description = "Agent service for Xnode reconfiguration and management";
      #license = with licenses; [ x ];
      maintainers = with maintainers; [ harrys522 ];
    };
}
