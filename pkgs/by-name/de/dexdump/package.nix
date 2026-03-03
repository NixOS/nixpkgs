{
  androidenv,
  stdenv,
}:
let
  buildTools = builtins.head androidenv.androidPkgs.build-tools;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dexdump";
  version = buildTools.version;

  buildCommand = ''
    mkdir -p $out/bin
    ln -s ${buildTools}/libexec/android-sdk/build-tools/${finalAttrs.version}/dexdump \
    $out/bin/dexdump
  '';

  meta = {
    inherit (buildTools.meta) license platforms;
    description = "Dexdump from Android SDK build-tools";
  };
})
