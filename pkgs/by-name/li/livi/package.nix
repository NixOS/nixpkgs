{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gst_all_1,
  wrapGAppsHook4,
  appstream-glib,
  gtk4,
  libadwaita,
  desktop-file-utils,
  libGL,
  appstream,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "livi";
  version = "0.5.0";

  src = fetchFromGitLab {
    owner = "guidog";
    repo = "livi";
    domain = "gitlab.gnome.org";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2GeukYT4hF68bD6h03mDLK1pIXJ/EKyB+2w7pjKa/+M=";
  };
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    appstream
    wayland-scanner
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gtk4
    libadwaita
    libGL
  ];
  strictDeps = true;

  meta = {
    homepage = "https://gitlab.gnome.org/guidog/livi";
    changelog = "https://gitlab.gnome.org/guidog/livi/-/blob/v${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Small video player targeting mobile devices (also named μPlayer)";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "livi";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
})
