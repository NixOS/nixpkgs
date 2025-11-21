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
}:

stdenv.mkDerivation rec {
  pname = "livi";
  version = "0.3.2";

  src = fetchFromGitLab {
    owner = "guidog";
    repo = "livi";
    domain = "gitlab.gnome.org";
    rev = "v${version}";
    hash = "sha256-cLvSK50RnXCYoXwpp+unTVnxqCkPa3Zr4dZT0TpYFpE=";
  };
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
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
    changelog = "https://gitlab.gnome.org/guidog/livi/-/blob/v${version}/NEWS?ref_type=tags";
    description = "Small video player targeting mobile devices (also named μPlayer)";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "livi";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
