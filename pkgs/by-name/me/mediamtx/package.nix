{
  lib,
  fetchFromGitHub,
  fetchurl,
  buildGoModule,
  nixosTests,
}:

let
  hlsJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/hls.js@v1.5.15/dist/hls.min.js";
    hash = "sha256-qRwhj9krOcLJKbGghAC8joXfNKXUdN7OkgEDosUWdd8=";
  };
in
buildGoModule rec {
  pname = "mediamtx";
  # check for hls.js version updates in internal/servers/hls/hlsjsdownloader/VERSION
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aHVSGyrLuLX/RYf1I1dDackmOeU3m24QcwBus4Uly0I=";
  };

  vendorHash = "sha256-YpwbFCfI2kfmX3nI1G9OGUv5qpZ/JMis5VyUkqsESZA=";

  postPatch = ''
    cp ${hlsJs} internal/servers/hls/hls.min.js
    echo "v${version}" > internal/core/VERSION
  '';

  subPackages = [ "." ];

  # Tests need docker
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) mediamtx;
  };

  meta = with lib; {
    description = "Ready-to-use RTSP server and RTSP proxy that allows to read and publish video and audio streams";
    inherit (src.meta) homepage;
    license = licenses.mit;
    mainProgram = "mediamtx";
    maintainers = with maintainers; [ fpletz ];
  };
}
