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
  spice-gtk,
  spice-protocol,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-connections";
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-connections/${lib.versions.major finalAttrs.version}/gnome-connections-${finalAttrs.version}.tar.xz";
    hash = "sha256-Oh+UZrpUkUdHI1+uIexuoybJf2+NAJDLmc+worJMc54=";
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
    spice-gtk
    spice-protocol
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-connections";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-connections";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-connections/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Remote desktop client for the GNOME desktop environment";
    mainProgram = "gnome-connections";
    teams = [ teams.gnome ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
})
