{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2015-12-27";
  src = fetchgit {
    sha256 = "4bf6e8815d2edbbc75255928d0fb030639a9fea9a5aa953dcf1f00e167eff527";
    rev = "cadb4b0fff00540159625320416e5601c4704627";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
