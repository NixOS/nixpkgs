{
  lib,
  stdenv,
  fetchurl,
}:
let
  # Must match the `v8` crate version in harness/core/Cargo.lock
  version = "150.3.0";

  fetch =
    { file, hashes }:
    fetchurl {
      name = "${file}-${version}";
      # deno_core enables the `simdutf` feature of the v8 crate
      url = "https://github.com/denoland/rusty_v8/releases/download/v${version}/${file}_simdutf_release_${stdenv.hostPlatform.rust.rustcTarget}${
        if file == "librusty_v8" then ".a.gz" else ".rs"
      }";
      hash =
        hashes.${stdenv.hostPlatform.system}
          or (throw "librusty_v8 is not available for ${stdenv.hostPlatform.system}");
      meta = {
        inherit version;
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      };
    };
in
{
  archive = fetch {
    file = "librusty_v8";
    hashes = {
      x86_64-linux = "sha256-2wl+bvpVp14L3oayuhl5g9CpG76DAfRVDEkNecB9evA=";
      aarch64-linux = "sha256-WR80+czoM+IAeYduyM4gsR0Y6jGk9BL0u6EQGB3ZdrY=";
      aarch64-darwin = "sha256-UfWFt8OGkwYSn/1haKjwuJqNSjhw3LBwlgwrT9fQSCU=";
    };
  };

  srcBinding = fetch {
    file = "src_binding";
    hashes = {
      x86_64-linux = "sha256-dyeCauR5vbZF6Acjn7EtH44uI956bPFvXuWSaQ0dhQY=";
      aarch64-linux = "sha256-dyeCauR5vbZF6Acjn7EtH44uI956bPFvXuWSaQ0dhQY=";
      aarch64-darwin = "sha256-ylrfDPicmnCtRgrnNkiy/om3SqETs8t/dXtqArdYOU8=";
    };
  };
}
