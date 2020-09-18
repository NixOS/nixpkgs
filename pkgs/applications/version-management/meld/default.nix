{ stdenv
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
  version = "3.20.2";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0a0x156zr3w2yg0rnhwy39giy3xnfm6sqcfa4xcw4i6ahvwqa2dc";
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
  ];

  buildInputs = [
    gtk3
    gtksourceview4
    gsettings-desktop-schemas
    gnome3.adwaita-icon-theme
    gobject-introspection # fixes https://github.com/NixOS/nixpkgs/issues/56943 for now
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pycairo
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Visual diff and merge tool";
    homepage = "http://meldmerge.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jtojnar mimame ];
  };
}
