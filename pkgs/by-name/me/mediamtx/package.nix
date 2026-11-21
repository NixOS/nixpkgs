{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  nixosTests,
  runCommand,
}:

let
  hlsJsVersion = "1.7.3";
  hlsJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/hls.js@v${hlsJsVersion}/dist/hls.min.js";
    hash = "sha256-oS5+4c1kpp3NsxQVfkXa/LpwW/sLFEC3k1yyZdN0Qj4=";
  };
in
buildGoModule (finalAttrs: {
  pname = "mediamtx";
  # check for hls.js version updates in internal/servers/hls/hlsjsdownloader/VERSION
  version = "1.21.4";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = "mediamtx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i5WoT3kWoNS3Mms3OUNY05oI00fKCfJd+IS48ZfYXew=";
  };

  vendorHash = "sha256-0WmP4SNqQKiC6Hrotz1Bhalss9i0p7DI4I0EOgZnxtY=";

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
    hlsjs-version = runCommand "mediamtx-hlsjs-version" { } ''
      expectedVersion=$(cat ${finalAttrs.src}/internal/servers/hls/hlsjsdownloader/VERSION)
      if [ "$expectedVersion" != "v${hlsJsVersion}" ]; then
        echo "hls.js version mismatch: upstream requires $expectedVersion, packaged version is v${hlsJsVersion}" >&2
        exit 1
      fi
      touch "$out"
    '';
  };

  meta = {
    description = "SRT, WebRTC, RTSP, RTMP, LL-HLS media server and media proxy";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.mit;
    mainProgram = "mediamtx";
    maintainers = with lib.maintainers; [ fpletz ];
  };
})
