{stdenv, fetchurl, ghc, zlib, ncurses}:

stdenv.mkDerivation {
  name = "darcs-1.0.3";
  src = fetchurl {
    url = http://abridgegame.org/darcs/darcs-1.0.3.tar.gz;
    md5 = "d3fc141d1c91044e45ae74b74fc54728";
  };
  buildInputs = [ghc zlib ncurses];
}
