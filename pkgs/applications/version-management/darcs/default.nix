{stdenv, fetchurl, ghc, zlib, ncurses, curl, getConfig}:

# you really should consider using darcs2 and updating your darcs-1 repos ..
# many performance improvements have been made if you use the darcs-2 or hashed format
# (darcs-2 is default now when runnig darcs 2.1.0)
# lookup darcs convert and make sure you understand the one way conversion..
assert getConfig ["darcs" "IreallyWantDarcsOne"] false;

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
