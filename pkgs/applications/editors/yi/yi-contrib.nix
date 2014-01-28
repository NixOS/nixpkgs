{ cabal, dataAccessor, filepath, mtl, split, yi }:

cabal.mkDerivation (self: {
  pname = "yi-contrib";
  version = "0.7.0";
  sha256 = "12x9ps5yrszr8dlj15kmsm9myq3gzd9x9nacvl3x6cq91wk53mzj";
  buildDepends = [ dataAccessor filepath mtl split yi ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Yi";
    description = "Add-ons to Yi, the Haskell-Scriptable Editor";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
