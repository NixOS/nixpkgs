{stdenv, fetchurl, ghc, zlib, ncurses, curl, perl}:

stdenv.mkDerivation {
  name = "darcs-2.1.0";
  src = fetchurl {
    url = http://www.darcs.net/darcs-2.1.0.tar.gz;
    sha256 = "d5a63e62bceb45905163d508c6b25158dab6aca367015566d8c539ec37107ab4";
  };

  buildInputs = [ghc zlib ncurses curl perl];

  NIX_LDFLAGS = "-lz";

  meta = {
    description = "Patch-based version management system";
  };

  patches = ./bash-completion.patch; # I didn't have "have"
}
