# auto-generated file -- DO NOT EDIT!
{
  lib,
  stdenv,
  fetchurl,
}:

fetchurl {
  name = "librusty_v8-146.4.0";
  url = "https://github.com/denoland/rusty_v8/releases/download/v146.4.0/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
  hash =
    {
      x86_64-linux = "sha256-5ktNmeSuKTouhGJEqJuAF4uhA4LBP7WRwfppaPUpEVM=";
      aarch64-linux = "sha256-2/FlsHyBvbBUvARrQ9I+afz3vMGkwbW0d2mDpxBi7Ng=";
      x86_64-darwin = "sha256-YwzSQPG77NsHFBfcGDh6uBz2fFScHFFaC0/Pnrpke7c=";
      aarch64-darwin = "sha256-v+LJvjKlbChUbw+WWCXuaPv2BkBfMQzE4XtEilaM+Yo=";
    }
    .${stdenv.hostPlatform.system}
      or (throw "librusty_v8 146.4.0 is not available for ${stdenv.hostPlatform.system}");
  meta = {
    version = "146.4.0";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
