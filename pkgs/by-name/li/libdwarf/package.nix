{
  callPackage,
  zlib,
  zstd,
}:

callPackage ./common.nix rec {
  version = "0.11.1";
  url = "https://www.prevanders.net/libdwarf-${version}.tar.xz";
  hash = "sha512:d927b1d0e8dd1540c2f5da2a9d39b2914bb48225b2b9bdca94e7b36349358e1f537044eadc345f11d75de717fdda07ad99a8a7a5eb45e64fe4c79c37e165012f";
  buildInputs = [
    zlib
    zstd
  ];
  knownVulnerabilities = [ ];
}
