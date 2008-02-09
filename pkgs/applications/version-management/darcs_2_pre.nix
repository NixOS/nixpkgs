{stdenv, fetchurl, ghc, zlib, ncurses, curl}:

stdenv.mkDerivation {
  name = "darcs-2.0.0pre3";
  src = fetchurl {
    url = http://darcs.net/darcs-2.0.0pre3.tar.gz;
    sha256 = "";
  };
  buildInputs = [ghc zlib ncurses curl];

  NIX_LDFLAGS = "-lz";

  meta = {
    description = "Patch-based version management system";
  };
}
