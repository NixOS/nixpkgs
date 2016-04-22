{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-04-23";
  src = fetchgit {
    sha256 = "11bf60cd5a6b314e855a69a6f57a5ca0db3254527def55662bce25810a2314df";
    rev = "c8169b1e656f7f95c67946298da5a0e1c143f8e8";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
