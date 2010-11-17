{cabal, curl, html, mtl, parsec, regexCompat, haskeline, hashedStorage, zlib, tar, text} :

cabal.mkDerivation (self : {
  pname = "darcs";
  name = self.fname;
  version = "2.5";
  sha256 = "0i99z3wsfc1hhr0a0ax7254gj3i69yg8cb9lhp55wl6lfqvpzcnh";

  propagatedBuildInputs = [
    curl html parsec regexCompat haskeline hashedStorage zlib tar text
  ];

  meta = {
    homepage = http://darcs.net/;
    description = "Patch-based version management system";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };

})
