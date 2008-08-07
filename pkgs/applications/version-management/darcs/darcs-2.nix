{stdenv, fetchurl, ghc, zlib, ncurses, curl}:

stdenv.mkDerivation {
  name = "darcs-2.0.0";
  src = fetchurl {
    url = http://darcs.net/darcs-2.0.0.tar.gz;
    sha256 = "1admaglbf7i15x9pihncqj5iraqzcw801pf76f0pd2hbc2k0yx7x";
  };
  buildInputs = [ghc zlib ncurses curl];

  NIX_LDFLAGS = "-lz";

  meta = {
    description = "Patch-based version management system";
  };

  patches = ./bash-completion.patch; # I didn't have "have"
}
