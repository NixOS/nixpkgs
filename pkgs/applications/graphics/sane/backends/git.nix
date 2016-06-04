{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-05-09";
  src = fetchgit {
    sha256 = "17y2l59vz2l0y5ya89390x6lim75p1mp8s5c2wzp9l4d5fy8j8dd";
    rev = "1e013654cc3af09f4731ab9ec8d8324d03a7de4a";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
