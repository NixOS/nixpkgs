{ requireFile, callPackage }:

callPackage ./runtime-build.nix rec {
  version = "20.5.684";
  eulaDate = "2021-10-13";
  src = requireFile {
    name = "houdini-${version}-linux_x86_64_gcc11.2.tar.gz";
    hash = "sha256-cyFeeKBCV1EGdgruQ71EnEJOVndn1SKSiCtD6WRc878=";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
  outputHash = "sha256-mAX4jSdV0/DC+48O7d1hgmKjC1leKm1QgSBMbyAxyFs=";
}
