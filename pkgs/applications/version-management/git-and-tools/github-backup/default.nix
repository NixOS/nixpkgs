{ cabal, extensibleExceptions, filepath, github, hslogger, IfElse
, MissingH, mtl, network, prettyShow
}:

cabal.mkDerivation (self: {
  pname = "github-backup";
  version = "1.20120627";
  sha256 = "1nq5zj821idvcqybyxkpkma544ci30k2sr8jhp7f2bpa97yidn3k";
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
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
