{
  lib,
  meson,
  ninja,
  fetchurl,
  desktop-file-utils,
  gdk-pixbuf,
  gettext,
  glib,
  gnome,
  gnome-desktop,
  gnome-settings-daemon,
  gnome-shell,
  gnome-shell-extensions,
  gobject-introspection,
  gsettings-desktop-schemas,
  gtk4,
  itstool,
  libadwaita,
  libgudev,
  libnotify,
  libxml2,
  mutter,
  pkg-config,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "gnome-tweaks";
  version = "49.rc";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-NON85In7878A8EIlO2wDW1/K5ZyVuOVSuKBgT+TpKfQ=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection
    itstool
    libxml2
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gnome-desktop
    gnome-settings-daemon
    gnome-shell
    # Makes it possible to select user themes through the `user-theme` extension
    gnome-shell-extensions
    mutter
    gsettings-desktop-schemas
    gtk4
    libadwaita
    libgudev
    libnotify
  ];

  pythonPath = with python3Packages; [
    pygobject3
  ];

  postPatch = ''
    patchShebangs meson-postinstall.py
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/libexec" "$out $pythonPath"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-tweaks";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-tweaks";
    description = "Tool to customize advanced GNOME 3 options";
    mainProgram = "gnome-tweaks";
    teams = [ teams.gnome ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
