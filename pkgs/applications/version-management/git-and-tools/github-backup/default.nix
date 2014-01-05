{ cabal, extensibleExceptions, filepath, git, github, hslogger
, IfElse, MissingH, mtl, network, prettyShow, text, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "github-backup";
  version = "1.20131203";
  sha256 = "0156g7zbqsp58g8hniqsilyc79sam7plwhn3w56wbzf8m380mwba";
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
