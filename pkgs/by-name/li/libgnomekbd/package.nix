{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  glib,
  gtk3,
  libxklavier,
  wrapGAppsHook3,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "libgnomekbd";
  version = "3.28.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "ItxZVm1zwAZTUPWpc0DmLsx7CMTfGRg4BLuL4kyP6HA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    glib
    gobject-introspection
  ];

  # Requires in libgnomekbd.pc
  propagatedBuildInputs = [
    gtk3
    libxklavier
    glib
  ];

  postInstall = ''
    # Missing post-install script.
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Keyboard management library";
    mainProgram = "gkbd-keyboard-display";
    teams = [ teams.gnome ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
