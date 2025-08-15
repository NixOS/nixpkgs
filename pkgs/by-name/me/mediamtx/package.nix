{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  nixosTests,
}:

let
  hlsJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/hls.js@v1.6.9/dist/hls.min.js";
    hash = "sha256-GObcOPuwxxMg0WOtl5BahSg9A3ds1IcCP+DPGZ8c27I=";
  };
in
buildGoModule (finalAttrs: {
  pname = "mediamtx";
  # check for hls.js version updates in internal/servers/hls/hlsjsdownloader/VERSION
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = "mediamtx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I1oKzovSv6hf2/lr2E5pRSqHV/pVoskNwn+gHRz8yv8=";
  };

  vendorHash = "sha256-5wSdbg7EAdvCUfIKxuX1aGihzHcwFM6Fiu/3eU1dMEY=";

  postPatch = ''
    cp ${hlsJs} internal/servers/hls/hls.min.js
    echo "v${finalAttrs.version}" > internal/core/VERSION

    # disable binary-only rpi camera support
    substituteInPlace internal/staticsources/rpicamera/camera_other.go \
      --replace-fail '!linux || (!arm && !arm64)' 'linux || !linux'
    substituteInPlace internal/staticsources/rpicamera/{params_serialize,pipe}.go \
      --replace-fail '(linux && arm) || (linux && arm64)' 'linux && !linux'
    substituteInPlace internal/staticsources/rpicamera/camera_arm32_.go \
      --replace-fail 'linux && arm' 'linux && !linux'
    substituteInPlace internal/staticsources/rpicamera/camera_arm64_.go \
      --replace-fail 'linux && arm64' 'linux && !linux'
    substituteInPlace internal/staticsources/rpicamera/camera_arm_.go \
      --replace-fail '(linux && arm) || (linux && arm64)' 'linux && !linux'
  '';

  subPackages = [ "." ];

  # Tests need docker
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) mediamtx;
  };

  meta = {
    description = "SRT, WebRTC, RTSP, RTMP, LL-HLS media server and media proxy";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.mit;
    mainProgram = "mediamtx";
    maintainers = with lib.maintainers; [ fpletz ];
  };
})
