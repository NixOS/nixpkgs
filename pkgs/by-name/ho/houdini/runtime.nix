{ requireFile, callPackage }:

callPackage ./runtime-build.nix rec {
  version = "21.0.512";
  eulaDate = "2021-10-13";
  src = requireFile {
    name = "houdini-${version}-linux_x86_64_gcc11.2.tar.gz";
    hash = "sha256-4cS7vDuQQgBZFmkZ+rk8WCaKGqGZNByh/lWxedadkNU=";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
  outputHash = "sha256-f/zrzI8KNpzMXT9QaWrC1tgN6lXNu+MdyGRj+XX3Clc=";
}
