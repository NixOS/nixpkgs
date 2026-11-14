{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  glib,
  gst_all_1,
}:

buildGoModule (finalAttrs: {
  pname = "livekit-ingress";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "ingress";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rvfBg9i2KlqBDM7GoiU3YzKI/IiocBWM42reAWrag7g=";
  };

  vendorHash = "sha256-YKwtohomUS8Z+ssfdhR0yzXKJnwQ9tLFXMirbathDDg=";

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
    changelog = "https://github.com/livekit/ingress/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/livekit/ingress";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ k900 ];
    mainProgram = "ingress";
  };
})
