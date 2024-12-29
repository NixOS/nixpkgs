{
  alsa-lib,
  fetchFromGitHub,
  ffmpeg,
  glib,
  gst_all_1,
  just,
  lib,
  libcosmicAppHook,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-player";
  version = "0-unstable-2024-12-15";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-player";
    rev = "011a2c7cc77b6f8ecb295974292357570b3f897d";
    hash = "sha256-ubU5nnMsKqUPdLc6QI5axT5IEM9XV95LuazIZCK2RSs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qm2ysSTKoIeJrRzNi1bEL9WoxEoAgqFu359gNNOVWBE=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    ffmpeg
    glib
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-player"
  ];

  postInstall = ''
    libcosmicAppWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-player";
    description = "Media player for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-player";

    maintainers = with maintainers; [
      thefossguy
    ];
  };
}
