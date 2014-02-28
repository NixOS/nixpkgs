{ cabal, dataAccessor, filepath, mtl, split, yi }:

cabal.mkDerivation (self: {
  pname = "yi-contrib";
  version = "0.7.1";
  sha256 = "0915ikck01kc5npbvywd9r7azylqrhfymzc72rf4iaghz4w939li";
  buildDepends = [ dataAccessor filepath mtl split yi ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Yi";
    description = "Add-ons to Yi, the Haskell-Scriptable Editor";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
