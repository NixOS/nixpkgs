<<<<<<< HEAD
{ stdenv, linuxHeaders, sourceProg, debug ? false }:
=======
{ stdenv, linuxHeaders, parentWrapperDir, debug ? false }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
# For testing:
# $ nix-build -E 'with import <nixpkgs> {}; pkgs.callPackage ./wrapper.nix { parentWrapperDir = "/run/wrappers"; debug = true; }'
stdenv.mkDerivation {
  name = "security-wrapper";
  buildInputs = [ linuxHeaders ];
  dontUnpack = true;
  hardeningEnable = [ "pie" ];
  CFLAGS = [
<<<<<<< HEAD
    ''-DSOURCE_PROG="${sourceProg}"''
=======
    ''-DWRAPPER_DIR="${parentWrapperDir}"''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
