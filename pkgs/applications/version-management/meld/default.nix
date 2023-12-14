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
, gnome
, gsettings-desktop-schemas
}:

python3.pkgs.buildPythonApplication rec {
  pname = "meld";
  version = "3.22.0";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-P8EHyY7251NY/9Kw0UyF3bSP4UoR6TmpQyL6qo6QxA0=";
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
    gnome.adwaita-icon-theme
  ];

  pythonPath = with python3.pkgs; [
    pygobject3
    pycairo
  ];

  postPatch = ''
    patchShebangs meson_shebang_normalisation.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none"; # should be odd-unstable but we are tracking unstable versions for now
    };
  };

  meta = with lib; {
    description = "Visual diff and merge tool";
    homepage = "https://meld.app/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jtojnar mimame ];
    mainProgram = "meld";
  };
}
