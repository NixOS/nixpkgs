{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-01-09";
  src = fetchgit {
    sha256 = "440f88a4126841cfd139b17902ceb940bbf189defe21b208e93bfd474cfb16e8";
    rev = "f78e85cad666492fadd5612af77fa7c84e270a12";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
