{cabal, html, mtl, parsec, regexCompat, zlib, curl} :

cabal.mkDerivation (self : {
  pname = "darcs";
  name = self.fname;
  version = "2.2.1";
  sha256 = "0iy4d4qls6yhwmgv87pz4kmr5jh4bwigz1wfwzns71b68csynnsp";

  extraBuildInputs = [html mtl parsec regexCompat zlib curl];

  meta = {
    homepage = http://darcs.net/;
    description = "Patch-based version management system";
  };

  patches = ./bash-completion.patch; # I didn't have "have"
})
