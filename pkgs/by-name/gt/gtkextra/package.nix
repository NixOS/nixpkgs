{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gobject-introspection,
  file,
  gtk2,
  glib,
  cairo,
  atk,
  pango,
  libtiff,
  libpng,
  libjpeg,
}:

stdenv.mkDerivation rec {
  pname = "gtkextra";
  version = "3.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/gtkextra/${lib.versions.majorMinor version}/${pname}-${version}.tar.gz";
    sha256 = "1mpihbyzhv3ymfim93l9xnxmzhwyqdba5xb4rdn5vggdg25766v5";
  };

  postPatch = ''
    substituteInPlace configure \
      --replace "/usr/bin/file" "${file}/bin/file"
  '';

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
  ];

  buildInputs = [
    gtk2
    glib
    cairo
    atk
    pango
    libtiff
    libpng
    libjpeg
  ];

  meta = with lib; {
    homepage = "https://gtkextra.sourceforge.net/";
    description = "GtkExtra is a useful set of widgets for creating GUI's for GTK+";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tesq0 ];
  };
}
