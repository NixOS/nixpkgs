{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gstreamer,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
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
  version = "0.6.1";

  src = fetchFromGitLab {
    owner = "guidog";
    repo = "livi";
    domain = "gitlab.gnome.org";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dEOQr/kZinaY6BiaWjo8wNeTuT30ZqPC6wTd+bVPMAU=";
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
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
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
