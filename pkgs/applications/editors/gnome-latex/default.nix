{ lib
, stdenv
, fetchurl
, fetchpatch
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
  version = "3.38.0";
  pname = "gnome-latex";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0xqd49pgi82dygqnxj08i1v22b0vwwhx3zvdinhrx4jny339yam8";
  };

  patches = [
    # Fix build with latest tepl.
    (fetchpatch {
      url = "https://gitlab.gnome.org/Archive/gnome-latex/commit/e1b01186f8a4e5d3fee4c9ccfbedd6d098517df9.patch";
      sha256 = "H8cbp5hDZoXytEdKE2D/oYHNKIbEFwxQoEaC4JMfGHY=";
    })
  ];

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
