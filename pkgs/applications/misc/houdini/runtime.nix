{ lib, stdenv, requireFile, callPackage}:

callPackage ./runtime-build.nix rec {
  version = "20.0.506";
  eulaDate = "2021-10-13";
  src = requireFile rec {
    name = "houdini-${version}-linux_x86_64_gcc11.2.tar.gz";
    sha256 = "10dcb695bf9bb6407ccfd91c67858d69864208ee97e1e9afe216abf99db549f5";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
}
