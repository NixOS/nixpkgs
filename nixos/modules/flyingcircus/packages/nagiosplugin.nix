{ pkgs ? import <nixpkgs> { }
, python34Packages ? pkgs.python34Packages
, stdenv ? pkgs.stdenv
, lib ? pkgs.lib
}:


python34Packages.buildPythonPackage rec {
  name = "nagiosplugin-${version}";
  version = "1.2.4";
  src = pkgs.fetchurl {
    url = "https://pypi.python.org/packages/f0/82/4c54ab5ee763c452350d65ce9203fb33335ae5f4efbe266aaa201c9f30ad/nagiosplugin-1.2.4.tar.gz";
    md5 = "f22ee91fc89d0c442803bdf27fab8c99";
  };

  doCheck = false;  # "cannot determine number of users (who failed)"
  dontStrip = true;
}
