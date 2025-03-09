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

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-connections";
  version = "48.rc";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-connections/${lib.versions.major finalAttrs.version}/gnome-connections-${finalAttrs.version}.tar.xz";
    hash = "sha256-TsdR3bSBSU9NIkVwlTgI0ZyedQ5JlWqmTZlNEtkMAUw=";
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
    updateScript = gnome.updateScript {
      packageName = "gnome-connections";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-connections";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-connections/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Remote desktop client for the GNOME desktop environment";
    mainProgram = "gnome-connections";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
})
