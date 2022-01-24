{ lib, buildGoPackage, fetchgit }:

buildGoPackage rec {
  pname = "git-annex-remote-b2";
  version = "20151212-${lib.strings.substring 0 7 rev}";
  rev = "4db46b9fc9ef7b3f4851c2a6b061cb8f90f553ba";

  goPackagePath = "github.com/encryptio/git-annex-remote-b2";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/encryptio/git-annex-remote-b2";
    sha256 = "1139rzdvlj3hanqsccfinprvrzf4qjc5n4f0r21jp9j24yhjs6j2";
  };

  goDeps = ./deps.nix;
}
