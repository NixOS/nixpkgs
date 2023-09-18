{ stdenv, linuxHeaders, sourceProg, debug ? false }:
# For testing:
# $ nix-build -E 'with import <nixpkgs> {}; pkgs.callPackage ./wrapper.nix { parentWrapperDir = "/run/wrappers"; debug = true; }'
stdenv.mkDerivation {
  name = "security-wrapper";
  buildInputs = [ linuxHeaders ];
  dontUnpack = true;
  hardeningEnable = [ "pie" ];
  CFLAGS = [
    ''-DSOURCE_PROG="${sourceProg}"''
  ] ++ (if debug then [
    "-Werror" "-Og" "-g"
  ] else [
    "-Wall" "-O2"
  ]);
  dontStrip = debug;
  installPhase = ''
    mkdir -p $out/bin
    $CC $CFLAGS ${./wrapper.c} -o $out/bin/security-wrapper
  '';
}
