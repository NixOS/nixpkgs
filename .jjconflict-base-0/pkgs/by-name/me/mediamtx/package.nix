{
  lib,
  fetchFromGitHub,
  fetchurl,
  buildGoModule,
  nixosTests,
}:

let
  hlsJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/hls.js@v1.5.17/dist/hls.min.js";
    hash = "sha256-SEBU6M0D0/bReB+39AK9wxjYpMUn+TOpXGJOJ8yalHA=";
  };
in
buildGoModule rec {
  pname = "mediamtx";
  # check for hls.js version updates in internal/servers/hls/hlsjsdownloader/VERSION
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2qFJujfnlpmiOAmDBPl3hrbbHDOZOWFy8Yh2VOU0FEI=";
  };

  vendorHash = "sha256-6MHtYrHZF3Oo53MV1Di0wGw9Xk+2CMei2XeoI0OcKsQ=";

  postPatch = ''
    cp ${hlsJs} internal/servers/hls/hls.min.js
    echo "v${version}" > internal/core/VERSION

    # disable binary-only rpi camera support
    substituteInPlace internal/staticsources/rpicamera/camera_disabled.go \
      --replace-fail '!linux || (!arm && !arm64)' 'linux'
    substituteInPlace internal/staticsources/rpicamera/{component,camera,params_serialize,pipe}.go \
      --replace-fail '(linux && arm) || (linux && arm64)' 'linux && !linux'
    substituteInPlace internal/staticsources/rpicamera/component_32.go \
      --replace-fail 'linux && arm' 'linux && !linux'
    substituteInPlace internal/staticsources/rpicamera/component_64.go \
      --replace-fail 'linux && arm64' 'linux && !linux'
  '';

  subPackages = [ "." ];

  # Tests need docker
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) mediamtx;
  };

  meta = with lib; {
    description = "SRT, WebRTC, RTSP, RTMP, LL-HLS media server and media proxy";
    inherit (src.meta) homepage;
    license = licenses.mit;
    mainProgram = "mediamtx";
    maintainers = with maintainers; [ fpletz ];
  };
}
