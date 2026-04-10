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
  libgee,
  gst_all_1,
  sqlite,
  xxHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "daikhan";
  version = "0.1-alpha5";

  src = fetchFromGitLab {
    owner = "daikhan";
    repo = "daikhan";
    tag = finalAttrs.version;
    hash = "sha256-pnvpjb/NqktZJJp3pkVpgYnJJzq+790CcmiVbDUQ4bs=";
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
    libgee
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-rs
    sqlite
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
    maintainers = [ ];
    mainProgram = "daikhan";
    platforms = lib.platforms.linux;
  };
})
