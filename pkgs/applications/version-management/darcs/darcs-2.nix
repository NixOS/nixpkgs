{stdenv, fetchurl, ghc, zlib, ncurses, curl, perl}:

stdenv.mkDerivation {
  name = "darcs-2.1.0pre3";
  src = fetchurl {
    url = http://www.darcs.net/darcs-2.1.0pre3.tar.gz;
    sha256 = "a4b63c16a20edef3e1dc06db29211b7272b51e6ef10e12924e6515fb71f58303";
  };

  buildInputs = [ghc zlib ncurses curl perl];

  NIX_LDFLAGS = "-lz";

  meta = {
    description = "Patch-based version management system";
  };

  patches = ./bash-completion.patch; # I didn't have "have"
}
