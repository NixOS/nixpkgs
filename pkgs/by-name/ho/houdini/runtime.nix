{ requireFile, callPackage }:

callPackage ./runtime-build.nix rec {
  version = "20.5.370";
  eulaDate = "2021-10-13";
  src = requireFile {
    name = "houdini-${version}-linux_x86_64_gcc11.2.tar.gz";
    hash = "sha256-QwPCU7E5yoJvWsiRUMBSAhEJYckbFTrQa1S4fto8dy0=";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
}
