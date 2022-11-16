{ stdenv, linuxHeaders, debug ? false }:
# For testing:
# $ nix-build -E 'with import <nixpkgs> {}; pkgs.callPackage ./wrapper.nix { parentWrapperDir = "/run/wrappers"; debug = true; }'

let
  elfHeaderSize = if stdenv.is64bit then
                    "64"
                  else if stdenv.is32bit then
                    "32"
                  else throw "unknown elf header size";
in
stdenv.mkDerivation {
  name = "nixos-security-wrapper";
  buildInputs = [ linuxHeaders ];
  dontUnpack = true;
  hardeningEnable = [ "pie" ];
  CFLAGS = [
    ''-DELF_HEADER_SIZE=${elfHeaderSize}''
  ] ++ (if debug then [
    "-Werror" "-Og" "-g"
  ] else [
    "-Wall" "-O2"
  ]);
  dontStrip = debug;

  installPhase = ''
    mkdir -p $out/bin
    $CC $CFLAGS ${./wrapper.c} -o $out/bin/nixos-security-wrapper
  '';
}
