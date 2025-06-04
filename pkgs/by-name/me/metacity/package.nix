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
  replaceVars,
  wrapGAppsHook3,
  zenity,
}:

stdenv.mkDerivation rec {
  pname = "metacity";
  version = "3.56.0";

  src = fetchurl {
    url = "mirror://gnome/sources/metacity/${lib.versions.majorMinor version}/metacity-${version}.tar.xz";
    hash = "sha256-dVSZcQSyb/DnmgKzeiuhib3058zVQibw+vSxpZAGyQE=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit zenity;
    })
  ];

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
    glib
    gsettings-desktop-schemas
    gtk3
    libcanberra-gtk3
    libgtop
    libstartup_notification
    zenity
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
    changelog = "https://gitlab.gnome.org/GNOME/metacity/-/blob/${version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
}
