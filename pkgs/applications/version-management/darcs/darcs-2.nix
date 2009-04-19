{cabal, html, mtl, parsec, regexCompat, zlib, curl} : /* , ghc, zlib, ncurses, curl, perl */

cabal.mkDerivation (self : {
  pname = "darcs";
  name = self.fname;
  version = "2.2.1";
  sha256 = "0iy4d4qls6yhwmgv87pz4kmr5jh4bwigz1wfwzns71b68csynnsp";

  extraBuildInputs = [html mtl parsec regexCompat zlib curl];
  #buildInputs = [ghc zlib ncurses curl perl];

  #NIX_LDFLAGS = "-lz";

  meta = {
    homepage = http://darcs.net/;
    description = "Patch-based version management system";
  };

  patches = ./bash-completion.patch; # I didn't have "have"
})
