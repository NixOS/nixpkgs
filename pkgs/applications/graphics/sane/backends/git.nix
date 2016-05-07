{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-05-07";
  src = fetchgit {
    sha256 = "5f8974bc56d5eb1d33fbe53b30e80395b690151a1ea418d8aa44c7e092656896";
    rev = "926bfade544de4a4fd5f1a8082b85a97e2443770";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
