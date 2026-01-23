{ requireFile, callPackage }:

callPackage ./runtime-build.nix rec {
  version = "21.0.440";
  eulaDate = "2021-10-13";
  src = requireFile {
    name = "houdini-${version}-linux_x86_64_gcc11.2.tar.gz";
    hash = "sha256-qHRR+RRtUgUam6FC1TWTZjg1FSakjLoMYVaiIfO+WOY=";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
  outputHash = "sha256-SSBiqNZRnxz6tnvusYRi2UASY1k3voiblDpkiu+qU0w=";
}
