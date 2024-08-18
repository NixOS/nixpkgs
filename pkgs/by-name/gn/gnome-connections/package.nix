{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  itstool,
  desktop-file-utils,
  wrapGAppsHook3,
  glib,
  gtk3,
  libhandy,
  libsecret,
  libxml2,
  gtk-vnc,
  gtk-frdp,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gnome-connections";
  version = "47.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-connections/${lib.versions.major version}/gnome-connections-${version}.tar.xz";
    hash = "sha256-seBKBfgKduzC6I9JbzzDXi8axccgNux093wTPaHMu9s=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    itstool
    desktop-file-utils
    glib # glib-compile-resources
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk-vnc
    gtk3
    libhandy
    libsecret
    libxml2
    gtk-frdp
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-connections"; };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/connections";
    description = "Remote desktop client for the GNOME desktop environment";
    mainProgram = "gnome-connections";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
