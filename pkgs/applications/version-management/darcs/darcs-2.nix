{cabal, html, mtl, parsec, regexCompat, curl, haskeline, hashedStorage, zlib} :

cabal.mkDerivation (self : {
  pname = "darcs";
  name = self.fname;
  version = "2.4.4";
  sha256 = "97cde35ae4b74488f8b98b487bc0498069eaa74fe035903394f3d4aff1da9f9e";

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
