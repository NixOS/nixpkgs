{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gst_all_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tauri-asset-gst-plugin";
  version = "0.1.0";

  # From upstream PR https://github.com/tauri-apps/tauri/pull/14402
  src = fetchFromGitHub {
    owner = "aaalloc";
    repo = "tauri";
    rev = "bc502b45a6995aab5687ce3e50b3d218ca5ee105";
    hash = "sha256-H27n2rsqmGbk7ru8K7LhEvvftpz6mxgTow/18SpQn1Q=";
  };

  cargoHash = "sha256-n9CZ92ezRP9i4JpARwLpW4KIo9/6cB481YuG3qN1BKo=";

  cargoBuildFlags = [ "--package tauri-asset-gst-plugin" ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gst_all_1.gstreamer
  ];

  postInstall = ''
    mkdir $out/lib/gstreamer-1.0
    mv $out/lib/*.so $out/lib/gstreamer-1.0/
  '';

  meta = {
    description = "GStreamer plugin to handle the tauri asset:// protocol";
    homepage = "https://github.com/tauri-apps/tauri/pull/14402";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ snu ];
    platforms = lib.platforms.linux;
  };
})
