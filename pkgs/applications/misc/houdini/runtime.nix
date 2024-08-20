{ requireFile, callPackage }:

callPackage ./runtime-build.nix rec {
  version = "20.5.278";
  eulaDate = "2021-10-13";
  src = requireFile {
    name = "houdini-${version}-linux_x86_64_gcc11.2.tar.gz";
    hash = "sha256-O5oAoiDiu+xrmDfTnilPqZue8+dXVTHnK0yrX6moTSc=";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
}
