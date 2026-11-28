{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "150.4.0";
  hashes = {
    x86_64-linux = "0xml6268gjs2pj7xf50gx3ly337c63j5l724b9hgrwfi235651zl";
    aarch64-linux = "09x5ck4fh3i90dfx1apambmmif0pwm18p19jdxwsb5m32lw2i7jk";
    aarch64-darwin = "1343g7vh3wa3vjaafif6v5gnb6chn7aq7bvh3nn7j6qcba6zvvss";
  };
in
stdenv.mkDerivation {
  name = "librusty_v8-${version}";

  src = fetchurl {
    url = "https://github.com/denoland/rusty_v8/releases/download/v${version}/librusty_v8_simdutf_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
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
