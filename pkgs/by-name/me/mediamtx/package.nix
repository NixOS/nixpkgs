{
  lib,
  fetchFromGitHub,
  fetchurl,
  buildGoModule,
  nixosTests,
}:

let
  hlsJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/hls.js@v1.5.20/dist/hls.min.js";
    hash = "sha256-0BbBIwSW7lnz9bAcFszkzAG1odPTV63sIAyQixMevkk=";
  };
in
buildGoModule rec {
  pname = "mediamtx";
  # check for hls.js version updates in internal/servers/hls/hlsjsdownloader/VERSION
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+NT3YheDdlTPnyGLUl9mpyYx2kvN1lw2jDRdAboTSdc=";
  };

  vendorHash = "sha256-aDBjxt3f7z/9LwYJ5KyteODGFO5u+7m/rovOd9363Fg=";

  postPatch = ''
    cp ${hlsJs} internal/servers/hls/hls.min.js
    echo "v${version}" > internal/core/VERSION

    # disable binary-only rpi camera support
    substituteInPlace internal/staticsources/rpicamera/camera_disabled.go \
      --replace-fail '!linux || (!arm && !arm64)' 'linux || !linux'
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
