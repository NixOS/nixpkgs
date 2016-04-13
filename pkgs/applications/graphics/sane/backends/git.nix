{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-04-06";
  src = fetchgit {
    sha256 = "af0b5943787bfe86169cd9bbf34284152e18b6df1f692773369545047e54a288";
    rev = "e6b6ad9d4847e86aed8be0837a19bfada881f52d";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
