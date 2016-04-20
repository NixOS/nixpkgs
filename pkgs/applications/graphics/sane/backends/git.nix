{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-04-20";
  src = fetchgit {
    sha256 = "f4a20eb41d72ff5961484ef164df44805a987523153107cc6f45acfb3d0208e2";
    rev = "4b2f171a13248a8e3d79379e368c54fb71ed97e2";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
