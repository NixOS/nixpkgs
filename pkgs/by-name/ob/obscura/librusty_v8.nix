{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "137.3.0";
  hashes = {
    x86_64-linux = "sha256-omgf3lMBir0zZgGPEyYX3VmAAt948VbHvG0v9gi1ZWc=";
    aarch64-linux = "sha256-42jQy0HBecQ6mQ5OxKVeRN2XYvHTS+FWlqzEQz+KbJI=";
  };
in
stdenv.mkDerivation {
  name = "librusty_v8-${version}";

  src = fetchurl {
    url = "https://github.com/denoland/rusty_v8/releases/download/v${version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
    hash =
      hashes.${stdenv.hostPlatform.system}
        or (throw "librusty_v8: unsupported platform ${stdenv.hostPlatform.system}");
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    gzip -cd "$src" > "$out"
    runHook postInstall
  '';

  meta = {
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames hashes;
  };
}
