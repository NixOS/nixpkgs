{ lib
, meson
, ninja
, fetchurl
, desktop-file-utils
, gdk-pixbuf
, gettext
, glib
, gnome
, gnome-desktop
, gnome-shell-extensions
, gobject-introspection
, gsettings-desktop-schemas
, gtk4
, itstool
, libadwaita
, libgudev
, libnotify
, libxml2
, pkg-config
, python3Packages
, wrapGAppsHook4
}:

python3Packages.buildPythonApplication rec {
  pname = "gnome-tweaks";
  version = "46.1";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-LxkqcIX71oQ+z4JXFtnaIeyScgKRSeo18+FZ4Kwwm4A=";
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
    gnome.gnome-settings-daemon
    gnome.gnome-shell
    # Makes it possible to select user themes through the `user-theme` extension
    gnome-shell-extensions
    gnome.mutter
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
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-tweaks";
    description = "Tool to customize advanced GNOME 3 options";
    mainProgram = "gnome-tweaks";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
