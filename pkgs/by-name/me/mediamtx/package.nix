{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  nixosTests,
}:

let
  hlsJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/hls.js@v1.6.12/dist/hls.min.js";
    hash = "sha256-z9adeEMx2bwAw7qDIPG+vRM/AQJ/zAJl0i4vaycHHaM=";
  };
in
buildGoModule (finalAttrs: {
  pname = "mediamtx";
  # check for hls.js version updates in internal/servers/hls/hlsjsdownloader/VERSION
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = "mediamtx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-omeaOAhH4adNpA0VXxcZkre3tGZUwHxBrIT85X3D+n0=";
  };

  vendorHash = "sha256-YSH8cu7+LIsJ3/o2FYBYlnc6adORJdzhCqQVH0252Ec=";

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
