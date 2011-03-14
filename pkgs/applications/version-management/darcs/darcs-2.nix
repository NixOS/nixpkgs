{cabal, curl, html, mtl, parsec, regexCompat, haskeline, hashedStorage, zlib, tar, text} :

cabal.mkDerivation (self : {
  pname = "darcs";
  name = self.fname;
  version = "2.5.1";
  sha256 = "0h7i2nw1fkmdrvwgzccqvbbfx8bdhn0h9d5rd98ayjs207dnvrj8";

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
