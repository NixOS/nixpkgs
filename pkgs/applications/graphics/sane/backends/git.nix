{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-06-11";
  src = fetchgit {
    sha256 = "0jpavig7bg7l72drlwipmsg03j6qdy5aq2r3kj6a2h6ahpnm2549";
    rev = "5ba37467e88ca8052973b37128ce8fd36ad5d61d";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
