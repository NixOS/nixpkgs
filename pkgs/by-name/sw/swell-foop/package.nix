{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  gtk4,
  libgee,
  libgnome-games-support_2_0,
  pango,
  gnome,
  desktop-file-utils,
  gettext,
  itstool,
  libxml2,
  wrapGAppsHook4,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "swell-foop";
  version = "46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/swell-foop/${lib.versions.major version}/swell-foop-${version}.tar.xz";
    hash = "sha256-BvireAfXHOyUi4aDcfR/ut7vzLXDV+E9HvPISBiR/KM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
    python3
    itstool
    gettext
    libxml2
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libgee
    libgnome-games-support_2_0
    pango
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "swell-foop"; };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/swell-foop";
    description = "Puzzle game, previously known as Same GNOME";
    mainProgram = "swell-foop";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
