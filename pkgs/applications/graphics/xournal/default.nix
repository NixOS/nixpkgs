{ stdenv, fetchurl
, ghostscript, atk, gtk, glib, fontconfig, freetype
, libgnomecanvas, libgnomeprint, libgnomeprintui
, pango, libX11, xproto, zlib, poppler
, autoconf, automake, libtool, pkgconfig}:
stdenv.mkDerivation rec {
  version = "0.4.8";
  name = "xournal-" + version;
  src = fetchurl {
    url = "mirror://sourceforge/xournal/${name}.tar.gz";
    sha256 = "0c7gjcqhygiyp0ypaipdaxgkbivg6q45vhsj8v5jsi9nh6iqff13";
  };

  buildInputs = [
    ghostscript atk gtk glib fontconfig freetype
    libgnomecanvas libgnomeprint libgnomeprintui
    pango libX11 xproto zlib poppler
  ];

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];

  NIX_LDFLAGS = [ "-lX11" "-lz" ];

  meta = {
    homepage = http://xournal.sourceforge.net/;
    description = "Note-taking application (supposes stylus)";
    maintainers = [ stdenv.lib.maintainers.guibert ];
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
