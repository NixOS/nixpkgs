{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "git-annex-remote-b2";
  version = "unstable-2015-12-12";

  goPackagePath = "github.com/encryptio/git-annex-remote-b2";

  src = fetchFromGitHub {
    owner = "encryptio";
    repo = "git-annex-remote-b2";
    rev = "4db46b9fc9ef7b3f4851c2a6b061cb8f90f553ba";
    sha256 = "sha256-QhotoSdCpiuDyMARW5jExP2887XRMaaxVXBIutvPaYQ=";
  };

  goDeps = ./deps.nix;
}
