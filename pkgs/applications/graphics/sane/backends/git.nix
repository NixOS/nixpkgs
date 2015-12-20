{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2015-12-20";
  src = fetchgit {
    sha256 = "998fdc9cdd3f9220c38244e0b87bba3ee623d7d20726479b04ed95b3836a37ed";
    rev = "5136e664b8608604f54a2cc1d466019922b311e6";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
