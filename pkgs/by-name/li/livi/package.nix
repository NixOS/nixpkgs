{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, gst_all_1
, wrapGAppsHook4
, appstream-glib
, gtk4
, libadwaita
, desktop-file-utils
, libGL
}:

stdenv.mkDerivation rec {
  pname = "livi";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "guidog";
    repo = "livi";
    domain = "gitlab.gnome.org";
    rev = "v${version}";
    sha256 = "sha256-FJ43BDRsZUFuRrNFWuEJ/nSO+suWad2QvqhwzuXWBtY=";
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

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/guidog/livi";
    description = "A small video player targeting mobile devices (also named μPlayer)";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "livi";
    maintainers = with maintainers; [ mksafavi ];
  };
}
