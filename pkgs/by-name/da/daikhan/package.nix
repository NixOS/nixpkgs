{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  desktop-file-utils,
  appstream,
  appstream-glib,
  blueprint-compiler,
  wrapGAppsHook4,
  libadwaita,
  gst_all_1,
  xxHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "daikhan";
  version = "0.1-alpha4";

  src = fetchFromGitLab {
    owner = "daikhan";
    repo = "daikhan";
    tag = finalAttrs.version;
    hash = "sha256-ocaeAm7ug56v9x4oPsfSeKp151OU1HuXkvm1WBazCC4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    desktop-file-utils
    appstream
    appstream-glib
    blueprint-compiler
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-rs
    xxHash
  ];

  mesonFlags = [
    (lib.mesonOption "profile" "stable")
  ];

  meta = {
    description = "Media player for the modern desktop";
    homepage = "https://gitlab.com/daikhan/daikhan";
    changelog = "https://gitlab.com/daikhan/daikhan/-/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "daikhan";
    platforms = lib.platforms.linux;
  };
})
