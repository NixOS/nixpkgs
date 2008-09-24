{stdenv, fetchurl, ghc, zlib, ncurses, curl, perl}:

stdenv.mkDerivation {
  name = "darcs-2.0.2";
  src = fetchurl {
    url = http://darcs.net/darcs-2.0.2.tar.gz;
    sha256 = "17plbfwz2rvzbvr9b90z55lj51ilnq22hhr38hffila1gsxqfk0n";
  };
  buildInputs = [ghc zlib ncurses curl perl];

  NIX_LDFLAGS = "-lz";

  meta = {
    description = "Patch-based version management system";
  };

  patches = ./bash-completion.patch; # I didn't have "have"
}
