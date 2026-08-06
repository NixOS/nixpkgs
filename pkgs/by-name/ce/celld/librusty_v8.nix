# auto-generated file -- DO NOT EDIT!
{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "152.0.0";
in
fetchurl {
  name = "librusty_v8-${version}";
  url = "https://github.com/denoland/rusty_v8/releases/download/v${version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
  hash =
    {
      x86_64-linux = "sha256-nS++EYCa01QTDVw3gmNqE89YaNptLAAtqIJ7hT01x+w=";
      aarch64-linux = "sha256-pTVYAE1/5QIGX1ucQrUHl5MLMM42DokTeZ2+wK7upA8=";
      aarch64-darwin = "sha256-q5Rw4GxkJlSae1lBIMTg8GAS5wEFzcOi9CGiv9YJqiA=";
    }
    .${stdenv.hostPlatform.system}
      or (throw "librusty_v8 ${version} is not available for ${stdenv.hostPlatform.system}");

  meta = {
    inherit version;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
