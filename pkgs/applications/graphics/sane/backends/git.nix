{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-05-09";
  src = fetchgit {
    sha256 = "5e3d647503d1231395a6782c6aa536b52b3d45585a87a0600ce0aca8b422cf82";
    rev = "1e013654cc3af09f4731ab9ec8d8324d03a7de4a";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
