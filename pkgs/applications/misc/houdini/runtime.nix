{ lib, stdenv, requireFile, callPackage}:

callPackage ./runtime-build.nix rec {
  version = "20.0.688";
  eulaDate = "2021-10-13";
  src = requireFile rec {
    name = "houdini-${version}-linux_x86_64_gcc11.2.tar.gz";
    sha256 = "99f9088824c328de9d351f037f26ff1cba960fbd9b4e2ed1d52601680d3512a6";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
}
