{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-02-19";
  src = fetchgit {
    sha256 = "d50971c106c8e0071d71daad7235776ac9a07a5ab0adb1e0eae5536b3021dd5f";
    rev = "d74d3bcd887d2a3d59ee96e04eb68f15c0a3b882";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
