{stdenv, fetchurl, ghc, zlib, ncurses, curl}:

stdenv.mkDerivation {
  name = "darcs-1.0.9";
  src = fetchurl {
    url = http://www.darcs.net/darcs-1.0.9.tar.gz;
    sha256 = "a5fe4d5a743d8052d6cbfcea480a44593f821afd8a42e6d6d4ae37d40ed23cd8";
  };
  buildInputs = [ghc zlib ncurses curl];

  NIX_LDFLAGS = "-lz";

  meta = {
    description = "Patch-based version management system";
  };
}
