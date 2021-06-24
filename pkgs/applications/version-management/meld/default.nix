{ lib
, fetchurl
, gettext
, itstool
, python3
, meson
, ninja
, wrapGAppsHook
, libxml2
, pkg-config
, desktop-file-utils
, gobject-introspection
, gtk3
, gtksourceview4
, gnome3
, gsettings-desktop-schemas
}:

python3.pkgs.buildPythonApplication rec {
  pname = "meld";
  version = "3.21.0";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "toARTVq3kzJFSf1Y9OsgLY4oDAYzoLdl7ebfs0FgqBs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    itstool
    libxml2
    pkg-config
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook
    gtk3 # for gtk-update-icon-cache
  ];

  buildInputs = [
    gtk3
    gtksourceview4
    gsettings-desktop-schemas
    gnome3.adwaita-icon-theme
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pycairo
  ];

  # gobject-introspection and some other similar setup hooks do not currently work with strictDeps.
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Visual diff and merge tool";
    homepage = "http://meldmerge.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jtojnar mimame ];
  };
}
