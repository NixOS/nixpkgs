{
  ffmpeg_7-headless,
  lib,
  fetchFromGitHub,
}:

(ffmpeg_7-headless.override {
  version = "7.0.1-unstable-2024-07-10";
  withCudaLLVM = true;
  source = fetchFromGitHub {
    owner = "livepeer";
    repo = "FFmpeg";
    rev = "d9751c73e714b01b363483db358b1ea8022c9bea"; # From branch n*-livepeer
    hash = "sha256-IJVpb/k+obGFD9uOoIVHCd2ZiGL3CA4CV3D+Q9vMbQM=";
  };
}).overrideAttrs
  (old: {
    pname = "ffmpeg-livepeer";

    meta = {
      inherit (old.meta)
        license
        mainProgram
        pkgConfigModules
        platforms
        ;
      maintainers = with lib.maintainers; [ bot-wxt1221 ];
    };
  })
