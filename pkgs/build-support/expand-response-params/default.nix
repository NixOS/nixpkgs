{ stdenv }:

#
# A "response file" is a sequence of arguments that is passed via a
# file, rather than via argv[].  These are used mainly for platforms
# like Windows and Darwin that have awkwardly-small limits on the
# amount of memory that argv[] can use.
#
stdenv.mkDerivation {
  name = "expand-response-params";
  src = ./expand-response-params.c;
  strictDeps = true;
  enableParallelBuilding = true;
  # Work around "stdenv-darwin-boot-2 is not allowed to refer to path
  # /nix/store/...-expand-response-params.c"
  unpackPhase = ''
    cp "$src" expand-response-params.c
    src=$PWD
  '';
  buildPhase = ''
    NIX_CC_USE_RESPONSE_FILE=0 "$CC" -std=c99 -O3 -o "expand-response-params" expand-response-params.c
  '';
  installPhase = ''
    mkdir -p $prefix/bin
    mv expand-response-params $prefix/bin/
  '';
}
