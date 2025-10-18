{
  src,
  version,
  lib,
  meta,
  stdenv,
  glibc,
}:
stdenv.mkDerivation {
  pname = "concourse-init";
  inherit version;
  meta = meta // {
    platforms = lib.platforms.linux;
    description = "Container init executable";
  };
  src = "${src}/cmd/init";
  buildInputs = [
    glibc.static
  ];
  buildPhase = ''
    mkdir -p $out
    gcc -O2 -static -o $out/init init.c
  '';
}
