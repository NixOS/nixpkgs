{ stdenv, fetchurl
, ghostscript, atk, gtk, glib, fontconfig, freetype
, libgnomecanvas, libgnomeprint, libgnomeprintui
, pango, libX11, xproto, zlib, poppler, popplerData
, autoconf, automake, libtool, pkgconfig}:
stdenv.mkDerivation rec {
  version = "0.4.5";
  name = "xournal-" + version;
  src = fetchurl {
    url = "mirror://sourceforge/xournal/${name}.tar.gz";
    sha256 = "1lamfzhby06w2pg56lpv1symdixcwmg6wvi7g6br6la4ak5w5mx7";
  };

  buildInputs = [
    ghostscript atk gtk glib fontconfig freetype
    libgnomecanvas libgnomeprint libgnomeprintui
    pango libX11 xproto zlib poppler popplerData
    autoconf automake libtool pkgconfig
  ];

  NIX_LDFLAGS="-lX11 -lz";
  meta = {
    description = "note-taking application (supposes stylus)";
    maintainers = [ stdenv.lib.maintainers.guibert ];
  };
}
