{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gst_all_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tauri-asset-gst-plugin";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "tauri-gstreamer-plugin";
    tag = "gst-plugin-tauri-v${finalAttrs.version}";
    hash = "sha256-bn2CnMRIjgLytO0bHMoKnU/gnqfF8ye8fZPrRHibjwE=";
  };

  cargoHash = "sha256-b0RcECJglSrjPe1FdSVUviaHIpoo89RkKRGXjLKAWJE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  postInstall = ''
    mkdir $out/lib/gstreamer-1.0
    mv $out/lib/*.so $out/lib/gstreamer-1.0/
  '';

  meta = {
    description = "GStreamer plugin to support media playback via Tauri's asset:// protocol";
    homepage = "https://github.com/tauri-apps/tauri-gstreamer-plugin/";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ snu ];
    platforms = lib.platforms.linux;
  };
})
