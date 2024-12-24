{
  callPackage,
  zlib,
  zstd,
}:

callPackage ./common.nix rec {
  version = "0.9.2";
  url = "https://www.prevanders.net/libdwarf-${version}.tar.xz";
  hash = "sha512-9QK22kuW1ZYtoRl8SuUiv9soWElsSvGYEJ2ETgAhMYyypevJyM+fwuRDmZfKlUXGUMpPKPDZbLZrBcm4m5jy+A==";
  buildInputs = [
    zlib
    zstd
  ];
  knownVulnerabilities = [ ];
}
