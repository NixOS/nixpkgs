{ cabal, dataAccessor, filepath, mtl, split, yi }:

cabal.mkDerivation (self: {
  pname = "yi-contrib";
  version = "0.7.2";
  sha256 = "074cq1y0pp66r2fqqszd8w2pws8jbfwq9g39w3rsgjnw83058fr8";
  buildDepends = [ dataAccessor filepath mtl split yi ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Yi";
    description = "Add-ons to Yi, the Haskell-Scriptable Editor";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
