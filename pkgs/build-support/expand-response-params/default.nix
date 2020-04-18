{ stdenv }:

stdenv.mkDerivation {
  name = "expand-response-params";
  src = ./expand-response-params.c;
  # Work around "stdenv-darwin-boot-2 is not allowed to refer to path
  # /nix/store/...-expand-response-params.c"
  unpackPhase = ''
    cp "$src" expand-response-params.c
    src=$PWD
  '';
  buildPhase = ''
    "$CC" -std=c99 -O3 -o "expand-response-params" expand-response-params.c
  '';
  installPhase = ''
    mkdir -p $prefix/bin
    mv expand-response-params $prefix/bin/
  '';
}
