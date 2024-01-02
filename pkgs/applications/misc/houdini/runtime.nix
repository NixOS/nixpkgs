{ lib, stdenv, requireFile, callPackage}:

let
  license_dir = "~/.config/houdini";
in
callPackage ./runtime-build.nix rec {
  version = "19.5.569";
  eulaDate = "2021-10-13";
  src = requireFile rec {
    name = "houdini-${version}-linux_x86_64_gcc9.3.tar.gz";
    sha256 = "0c2d6a31c24f5e7229498af6c3a7cdf81242501d7a0792e4c33b53a898d4999e";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
}
