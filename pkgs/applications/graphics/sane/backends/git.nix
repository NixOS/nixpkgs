{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-02-22";
  src = fetchgit {
    sha256 = "476abced4a9ccc95eb0796ef1d2e1d9be76c0db14adc248a9feaae3c8a61645e";
    rev = "a74ebe551daf8750821b1ab57324e54141a84461";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
