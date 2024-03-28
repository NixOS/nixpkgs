{
  fetchFromGitHub
, stdenv
, lib
}:

let
  mkComfyUICustomNodes = args: stdenv.mkDerivation ({
    installPhase = ''
      runHook preInstall
      mkdir -p $out/
      cp -r $src/* $out/
      runHook postInstall
    '';

    passthru.dependencies = [];
  } // args);
in
{
  ultimate-sd-upscale = mkComfyUICustomNodes {
    pname = "ultimate-sd-upscale";
    version = "unstable-2023-08-16";

    src = fetchFromGitHub {
      owner = "ssitu";
      repo = "ComfyUI_UltimateSDUpscale";
      rev = "6ea48202a76ccf5904ddfa85f826efa80dd50520";
      hash = "sha256-fUZ0AO+LARa+x30Iu+8jvEDun4T3f9G0DOlB2XNxY9Q=";
      fetchSubmodules = true;
    };
  };
}
