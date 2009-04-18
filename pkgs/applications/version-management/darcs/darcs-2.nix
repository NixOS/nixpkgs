{cabal /* , ghc, zlib, ncurses, curl, perl */}:

cabal.mkDerivation (self : {
  pname = "darcs";
  version = "2.2.1";
  sha256 = "0iy4d4qls6yhwmgv87pz4kmr5jh4bwigz1wfwzns71b68csynnsp";

  #buildInputs = [ghc zlib ncurses curl perl];

  #NIX_LDFLAGS = "-lz";

  meta = {
    homepage = http://darcs.net/;
    description = "Patch-based version management system";
  };

  patches = ./bash-completion.patch; # I didn't have "have"
})
