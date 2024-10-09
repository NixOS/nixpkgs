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
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DCt0P0DHlWFAQ5i4+7U5+Q2XcCPlSZrlj+Ljcyg/Wj0=";
  };

  vendorHash = "sha256-YKNNQPEdO8K7Lpm/S86GKD3QcNcyvwZSrBspZJMJ78Y=";

  postPatch = ''
    cp ${hlsJs} internal/servers/hls/hls.min.js
  '';

  # Tests need docker
  doCheck = false;

  ldflags = [ "-X github.com/bluenviron/mediamtx/internal/core.version=v${version}" ];

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
