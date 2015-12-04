{ stdenv, buildPythonPackage, pkgs, lib, ...}:

buildPythonPackage rec {
  name = "nagiosplugin-1.2.2";
  src = pkgs.fetchurl {
    url = "https://pypi.python.org/packages/source/n/nagiosplugin/${name}.tar.gz";
    md5 = "c85e1641492d606d929b02aa262bf55d";
  };

  doCheck = false;  # "cannot determine number of users (who failed)"
}
