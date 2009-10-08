{cabal, html, mtl, parsec, regexCompat, curl, haskeline, hashedStorage} :

cabal.mkDerivation (self : {
  pname = "darcs";
  name = self.fname;
  version = "2.3.1";
  sha256 = "14821bb2db4975cb4db2c5cc4f085069b936da591b7b71592befc9e07f17d214";

  extraBuildInputs = [html parsec regexCompat curl haskeline hashedStorage];

  meta = {
    homepage = http://darcs.net/;
    description = "Patch-based version management system";
  };

})
