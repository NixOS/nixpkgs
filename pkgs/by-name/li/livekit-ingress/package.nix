{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  glib,
  gst_all_1,
}:

buildGoModule rec {
  pname = "livekit-ingress";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "ingress";
    tag = "v${version}";
    hash = "sha256-gt1oIAKEBwQWqDCLSsRgoe7oIk5jDNReN+dFYUNnRUc=";
  };

  vendorHash = "sha256-fttI+xNzHiDWKGkl20oGJOcWffElmmqNd7gbb5FiQZc=";

  subPackages = [ "cmd/server" ];

  postInstall = ''
    mv $out/bin/server $out/bin/ingress
    wrapProgram $out/bin/ingress --suffix GST_PLUGIN_SYSTEM_PATH_1_0 ":" $GST_PLUGIN_SYSTEM_PATH_1_0
  '';

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = with gst_all_1; [
    glib
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ];

  # there are no actual tests, and we don't need to spend
  # another 5 minutes of cgo to figure that out
  doCheck = false;

  meta = {
    description = "Ingest streams (RTMP/WHIP) or files (HLS, MP4) to LiveKit WebRTC";
    changelog = "https://github.com/livekit/ingress/releases/tag/${src.tag}";
    homepage = "https://github.com/livekit/ingress";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ k900 ];
    mainProgram = "ingress";
  };
}
