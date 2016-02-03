{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-01-25";
  src = fetchgit {
    sha256 = "db1fecd671bd8b3a777138bb4815285b4364ee3ad01ab05424b4aa0c20ed9919";
    rev = "056f590f2d147099554d97a89dd5e0ddfa8d6dda";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
