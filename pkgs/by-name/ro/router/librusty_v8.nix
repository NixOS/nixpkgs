{ lib, stdenv, fetchurl }:

let
  fetch_librusty_v8 = args: fetchurl {
    name = "librusty_v8-${args.version}";
    url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a";
    sha256 = args.shas.${stdenv.hostPlatform.system};
    meta = {
      inherit (args) version;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  };
in
fetch_librusty_v8 {
  version = "0.74.3";
  shas = {
    x86_64-linux = "sha256-8pa8nqA6rbOSBVnp2Q8/IQqh/rfYQU57hMgwU9+iz4A=";
    aarch64-linux = "sha256-3kXOV8rlCNbNBdXgOtd3S94qO+JIKyOByA4WGX+XVP0=";
    x86_64-darwin = "sha256-iBBVKZiSoo08YEQ8J/Rt1/5b7a+2xjtuS6QL/Wod5nQ=";
    aarch64-darwin = "sha256-Djnuc3l/jQKvBf1aej8LG5Ot2wPT0m5Zo1B24l1UHsM=";
  };
}
