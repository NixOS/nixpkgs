{
  lib,
  stdenv,
  fetchurl,
}:

let
  fetch_librusty_v8 =
    args:
    fetchurl {
      name = "librusty_v8-${args.version}";
      url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
      hash = args.shas.${stdenv.hostPlatform.system};
      meta = {
        inherit (args) version;
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      };
    };
in
fetch_librusty_v8 {
  version = "0.97.1";
  shas = {
    x86_64-linux = "sha256-wQBEi2Vs5ruhSkq0n3z8WWjls6V3th2cm+O6s4LDB8k=";
    aarch64-linux = "sha256-U0PCUNcshm7AaBuUgwQQ1Qn9dr1iL2Okodl6BI/nZR8=";
    x86_64-darwin = "sha256-cGXOstCOdqaOpU2LcOT5A0JfnkoDvUHhOcCJ9vsS7CM=";
    aarch64-darwin = "sha256-9TmAON0KUVRQISTudyryIhf4VC/Dc4caq69iquDdrTU=";
  };
}
