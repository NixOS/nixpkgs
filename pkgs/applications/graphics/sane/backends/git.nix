{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2016-01-01";
  src = fetchgit {
    sha256 = "412c88b2b2b699b5a2ab28c7696c715e46b600398391ae038840c6b8674aea7c";
    rev = "3f0c3df2fcde8d0cf30ab68c70cb5cad984dda6f";
    url = "git://alioth.debian.org/git/sane/sane-backends.git";
  };
})
