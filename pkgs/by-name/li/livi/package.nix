{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, gst_all_1
, appstream-glib
, gtk4
, libadwaita
, desktop-file-utils
, libGL
}:

stdenv.mkDerivation rec {
  pname = "livi";
  version = "v0.0.6";

  src = fetchFromGitLab {
    owner = "guidog";
    repo = "livi";
    domain = "gitlab.gnome.org";
    rev = "${version}";
    sha256 = "sha256-DaIbBCJT4Da5noW6Q5z1yzTZ256HNqrvdXgwSY7p/D8=";
  };

  buildInputs = [
    meson
    ninja
    pkg-config
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
    appstream-glib
    gtk4
    libadwaita
    desktop-file-utils
    libGL
  ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/guidog/livi";
    description = "μPlayer A small video player targeting mobile devices";
    maintainers = with maintainers; [ mksafavi ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
