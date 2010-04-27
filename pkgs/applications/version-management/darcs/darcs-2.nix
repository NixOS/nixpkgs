{cabal, html, mtl, parsec, regexCompat, curl, haskeline, hashedStorage, zlib} :

cabal.mkDerivation (self : {
  pname = "darcs";
  name = self.fname;
  version = "2.4.1";
  sha256 = "6ac0e84d2eca160e6e33755679dfb185d9b5f9f5bdc43f99db326210aabbc4aa";

  extraBuildInputs = [
    html parsec regexCompat curl haskeline hashedStorage zlib
  ];

  meta = {
    homepage = http://darcs.net/;
    description = "Patch-based version management system";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };

})
