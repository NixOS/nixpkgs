{ stdenv, fetchurl, wrapGAppsHook, gsettings-desktop-schemas, gspell, gtksourceview4, libgee
, tepl, amtk, gnome3, glib, pkgconfig, intltool, itstool, libxml2 }:
let
  version = "3.36.0";
  pname = "gnome-latex";
in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1869kr1zhcp04mzbi67lwgk497w840dbbc7427i9yh9b9s7j6mqn";
  };

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";
  configureFlags = ["--disable-dconf-migration"];

  nativeBuildInputs = [
    pkgconfig
    wrapGAppsHook
    itstool
    intltool
  ];

  buildInputs = [
    amtk
    gnome3.adwaita-icon-theme
    glib
    gsettings-desktop-schemas
    gspell
    gtksourceview4
    libgee
    libxml2
    tepl
  ];

  doCheck = true;

  passthru.updateScript = gnome3.updateScript { packageName = pname; };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/GNOME-LaTeX";
    description = "A LaTeX editor for the GNOME desktop";
    maintainers = [ maintainers.manveru ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
