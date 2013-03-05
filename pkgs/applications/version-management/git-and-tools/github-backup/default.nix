{ cabal, fetchurl, extensibleExceptions, filepath, github, hslogger, IfElse
, MissingH, mtl, network, prettyShow
}:

cabal.mkDerivation (self: {
  pname = "github-backup";
  version = "1.20120314";
  src = fetchurl {
    url = "https://github.com/joeyh/github-backup/archive/1.20120314.tar.gz";
    sha256 = "0rmgkylsnxbry02g5bxq5af03azgydfz6dzyvqzbhnkwavhqdlqy";
    name = "github-backup-${self.pname}.tar.gz";
  };
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
