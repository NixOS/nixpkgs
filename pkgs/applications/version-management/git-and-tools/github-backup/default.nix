{ cabal, extensibleExceptions, filepath, github, hslogger, IfElse
, MissingH, mtl, network, prettyShow
}:

cabal.mkDerivation (self: {
  pname = "github-backup";
  version = "1.20120314";
  sha256 = "07ilb6cg1kbz4id53l4m46wjxzs7yxcmpz6280ym6k885dras5v2";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    extensibleExceptions filepath github hslogger IfElse MissingH mtl
    network prettyShow
  ];
  meta = {
    homepage = "https://github.com/joeyh/github-backup";
    description = "backs up everything github knows about a repository, to the repository";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
