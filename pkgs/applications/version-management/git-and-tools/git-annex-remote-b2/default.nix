{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "git-annex-remote-b2-${version}";
  version = "20151212-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "4db46b9fc9ef7b3f4851c2a6b061cb8f90f553ba";

  goPackagePath = "github.com/encryptio/git-annex-remote-b2";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/encryptio/git-annex-remote-b2";
    sha256 = "1139rzdvlj3hanqsccfinprvrzf4qjc5n4f0r21jp9j24yhjs6j2";
  };

  goDeps = ./deps.json;
}
