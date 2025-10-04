{
  lib,
  stdenv,
  fetchurl,
  gettext,
  glib,
  gnome,
  gsettings-desktop-schemas,
  gtk3,
  xorg,
  libcanberra-gtk3,
  libgtop,
  libstartup_notification,
  libxml2,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "metacity";
  version = "3.57.1";

  src = fetchurl {
    url = "mirror://gnome/sources/metacity/${lib.versions.majorMinor finalAttrs.version}/metacity-${finalAttrs.version}.tar.xz";
    hash = "sha256-EpOibk3t/UvyALW7eIZzAIl5rjrG0wU/fbSBuHrMfN4=";
  };

  nativeBuildInputs = [
    gettext
    libxml2
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    xorg.libXres
    xorg.libXpresent
    xorg.libXdamage
    xorg.libX11
    glib
    gsettings-desktop-schemas
    gtk3
    libcanberra-gtk3
    libgtop
    libstartup_notification
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "metacity";
      versionPolicy = "odd-unstable";
    };
  };

  doCheck = true;

  meta = {
    description = "Window manager used in Gnome Flashback";
    homepage = "https://gitlab.gnome.org/GNOME/metacity";
    changelog = "https://gitlab.gnome.org/GNOME/metacity/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})
