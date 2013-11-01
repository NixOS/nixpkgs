{ cabal, extensibleExceptions, filepath, git, github, hslogger
, IfElse, MissingH, mtl, network, prettyShow, text, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "github-backup";
  version = "1.20131006";
  sha256 = "0yc2hszi509mc0d6245dc8cq20mjjmr8mgrd8571dy9sgda532pf";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    extensibleExceptions filepath github hslogger IfElse MissingH mtl
    network prettyShow text unixCompat
  ];
  buildTools = [ git ];
  meta = {
    homepage = "https://github.com/joeyh/github-backup";
    description = "backs up everything github knows about a repository, to the repository";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
