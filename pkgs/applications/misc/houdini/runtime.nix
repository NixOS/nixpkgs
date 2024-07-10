{ lib, stdenv, requireFile, callPackage}:

callPackage ./runtime-build.nix rec {
  version = "20.5.278";
  eulaDate = "2021-10-13";
  src = requireFile rec {
    name = "houdini-${version}-linux_x86_64_gcc11.2.tar.gz";
    sha256 = "09sdm2lmzasc5gkk2mapwzrrx6x99wlrxlrpk1myrfz242i016iv";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
}
