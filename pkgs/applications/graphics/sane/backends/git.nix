{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-02-25";
  src = fetchgit {
    sha256 = "842b1186d38de14221be514a58f77c23d9f83979ea45f846440cf9cbb1f26c1f";
    rev = "c5117ed0f1b522eab10fd2248f140b2acad2a708";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
