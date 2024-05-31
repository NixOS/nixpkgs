{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, python3Packages ? pkgs.python3Packages
, fetchFromGitHub ? pkgs.fetchFromGitHub
}:

python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "572ef943713fda0ef7a90f59b43980b7307f2b15";
    sha256 = "18bhc64yyrcmbb6fblg1b6a6nmmy01hyalnphl01jawki83mrfbi";
  };

  nativeBuildInputs = [
    pkgs.python311Packages.hatchling
  ];

  propagatedBuildInputs = [
    pkgs.python311Packages.gitpython
  ];

  meta = with lib; {
      homepage = "https://openmesh.network/";
      description = "Agent service for Xnode reconfiguration and management";
      #license = with licenses; [ x ];
      maintainers = with maintainers; [ harrys522 ];
    };
}