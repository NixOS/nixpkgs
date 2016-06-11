{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-06-11";
  src = fetchgit {
    sha256 = "6312c514e3c47f3f7003e3f54750485950720aaa35c8f0e5b7a361bc04e2a795";
    rev = "5ba37467e88ca8052973b37128ce8fd36ad5d61d";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
