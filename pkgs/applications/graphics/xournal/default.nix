{ stdenv, fetchurl
, ghostscript, atk, gtk, glib, fontconfig, freetype
, libgnomecanvas, libgnomeprint, libgnomeprintui
, pango, libX11, xproto, zlib, poppler, poppler_data
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
    pango libX11 xproto zlib poppler poppler_data
  ];

  buildNativeInputs = [ autoconf automake libtool pkgconfig ];

  # Build with poppler-0.18.x
  patchFlags = "-p0";

  patches = [ (fetchurl {
      url = "https://api.opensuse.org/public/source/X11:Utilities/xournal/xournal-poppler-0.18.patch?rev=eca1c0b24f5bc78111147ab8f4688455";
      sha256 = "1q565kqb4bklncriq4dlhp1prhidv88wmxr9k3laykiia0qjmfyj";
    })];

  NIX_LDFLAGS="-lX11 -lz";

  meta = {
    homepage = http://xournal.sourceforge.net/;
    description = "note-taking application (supposes stylus)";
    maintainers = [ stdenv.lib.maintainers.guibert ];
  };
}
