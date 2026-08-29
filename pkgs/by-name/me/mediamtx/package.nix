{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  fetchurl,
  nixosTests,
}:

let
  hlsJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/hls.js@v1.6.15/dist/hls.min.js";
    hash = "sha256-QTqD4rsMd+0L8L4QXVOdF+9F39mEoLE+zTsUqQE4OTg=";
  };
in
buildGo126Module (finalAttrs: {
  pname = "mediamtx";
  # check for hls.js version updates in internal/servers/hls/hlsjsdownloader/VERSION
  version = "1.19.2";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = "mediamtx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jUyA0XjR92I6RNTXtFKqrUG0v7P3DDnoThWHSxTQE2I=";
  };

  vendorHash = "sha256-i3J91K0aQ6/vC+HsJjjjWNjl9vX9uOSEzmNjB6cMU6Q=";

  postPatch = ''
    cp ${hlsJs} internal/servers/hls/hls.min.js
    echo "v${finalAttrs.version}" > internal/core/VERSION

    # disable binary-only rpi camera support
    substituteInPlace internal/staticsources/rpicamera/source_other.go \
      --replace-fail '!linux || (!arm && !arm64)' 'linux || !linux'
    substituteInPlace internal/staticsources/rpicamera/*_arm_.go \
      --replace-fail '(linux && arm) || (linux && arm64)' 'linux && !linux'
    rm internal/staticsources/rpicamera/camera_linux_arm*.go
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
