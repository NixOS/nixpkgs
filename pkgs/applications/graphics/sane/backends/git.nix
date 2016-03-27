{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-03-24";
  src = fetchgit {
    sha256 = "593672ccfef6e3e0f3cb8ae4bbc67db9b2f1a821df4914343e4cf32f75cea865";
    rev = "41a416e4afcf6cada69193dc408ef184d0e5f678";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
