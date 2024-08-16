{ stdenv, lib }:

# A "response file" is a sequence of arguments that is passed via a
# file, rather than via argv[].

# For more information see:
# https://gcc.gnu.org/wiki/Response_Files
# https://www.intel.com/content/www/us/en/docs/dpcpp-cpp-compiler/developer-guide-reference/2023-0/use-response-files.html

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

  meta = {
    description = "Internal tool used by the nixpkgs wrapper scripts for processing response files";
    longDescription = ''
      expand-response-params is a tool that allows for obtaining a full list of all
      arguments passed in a given compiler command line including those passed via
      so-called response files. The nixpkgs wrapper scripts for bintools and C
      compilers use it for processing compiler flags. As it is developed in
      conjunction with the nixpkgs wrapper scripts, it should be considered as
      unstable and subject to change.
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
