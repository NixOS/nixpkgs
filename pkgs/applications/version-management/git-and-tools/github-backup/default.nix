{ cabal, extensibleExceptions, filepath, git, github, hslogger
, IfElse, MissingH, mtl, network, prettyShow, text, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "github-backup";
  version = "1.20131101";
  sha256 = "07l8a3xiy65xicxa5v14li6jnj3niwhndm8gd6q4d7aw14yq8wbn";
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
