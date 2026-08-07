{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "137.3.0";
  hashes = {
    x86_64-linux = "0rv5nl4gcbvdpk3mdwbqvw180nfx2wk173q1cqrvv2h1agg1ys52";
    aarch64-linux = "14kci8zl7i5cjrbf2jyky5i9gpa4bsjw8khfk4xc8yf1875x0s73";
  };
in
stdenv.mkDerivation {
  name = "librusty_v8-${version}";

  src = fetchurl {
    url = "https://github.com/denoland/rusty_v8/releases/download/v${version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
    sha256 =
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
