{ stdenv
, lib
, fetchurl
, autoreconfHook
, gtk-doc
, vala
, gobject-introspection
, wrapGAppsHook
, gsettings-desktop-schemas
, gspell
, gtksourceview4
, libgee
, tepl
, amtk
, gnome
, glib
, pkg-config
, intltool
, itstool
, libxml2
}:

stdenv.mkDerivation rec {
  version = "3.40.0";
  pname = "gnome-latex";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "xad/55vUDjeOooyPRaZjJ/vIzFw7W48PCcAhfufMCpA=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gtk-doc
    vala
    gobject-introspection
    wrapGAppsHook
    itstool
    intltool
  ];

  buildInputs = [
    amtk
    gnome.adwaita-icon-theme
    glib
    gsettings-desktop-schemas
    gspell
    gtksourceview4
    libgee
    libxml2
    tepl
  ];

  configureFlags = [
    "--disable-dconf-migration"
  ];

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  passthru.updateScript = gnome.updateScript {
    packageName = pname;
    versionPolicy = "odd-unstable";
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/GNOME-LaTeX";
    description = "A LaTeX editor for the GNOME desktop";
    maintainers = [ maintainers.manveru ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
