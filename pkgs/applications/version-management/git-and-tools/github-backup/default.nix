{ cabal, extensibleExceptions, filepath, github, hslogger, IfElse
, MissingH, mtl, network, prettyShow, text
}:

cabal.mkDerivation (self: {
  pname = "github-backup";
  version = "1.20130414";
  sha256 = "1s8s1kv4kj086kzq8iq28zyrlg65hrzg3563fw3dazfik73cmlcp";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    extensibleExceptions filepath github hslogger IfElse MissingH mtl
    network prettyShow text
  ];
  meta = {
    homepage = "https://github.com/joeyh/github-backup";
    description = "backs up everything github knows about a repository, to the repository";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
