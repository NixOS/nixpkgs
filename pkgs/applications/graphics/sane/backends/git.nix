{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-04-14";
  src = fetchgit {
    sha256 = "414fa7753043f8f3775d926eede01a9dbccf6255b2b2b961a3c48b4fa76a4952";
    rev = "19c128a23e27c1ab5a030fa6ff74da1b740629bb";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
