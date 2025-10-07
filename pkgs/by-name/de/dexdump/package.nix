{
  androidenv,
  stdenv,
  lib,
}:
let
  buildTools = builtins.head androidenv.androidPkgs.build-tools;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dexdump";
  version = "36.0.0";

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${buildTools}/libexec/android-sdk/build-tools/${finalAttrs.version}/dexdump \
      $out/bin/dexdump
  '';

  meta = {
    description = "Dexdump from Android SDK build-tools";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
