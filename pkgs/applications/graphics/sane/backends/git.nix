{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-03-05";
  src = fetchgit {
    sha256 = "dc84530d5e0233427acfd132aa08a4cf9973c936ff72a66ee08ecf836200d367";
    rev = "23eb95582da718791103b83ea002e947caa0f5fc";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
