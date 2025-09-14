{
  src,
  version,
  config,
  lib,
  pkgs,
  stdenv,
  glibc,
  ...
}:
stdenv.mkDerivation {
  pname = "init";
  inherit version;
  src = "${src}/cmd/init";
  buildInputs = [
    glibc.static
  ];
  buildPhase = ''
    mkdir -p $out
    gcc -O2 -static -o $out/init init.c
  '';
}
