{ teletextSupport ? true
, jpegSupport ? true
, pngSupport ? true
# !!! libXext shouldn't be necessary (it's in x11); but the builder needs it.
, stdenv, fetchurl, pkgconfig, perl, python, x11, libXv, libXmu, libXext, libgnomeui
, libglade, scrollkeeper, esound, gettext, perlXMLParser
, zvbi ? null, libjpeg ? null, libpng ? null }:

assert pkgconfig != null && perl != null && python != null
  && x11 != null && libXv != null && libXmu != null && libgnomeui != null && libglade != null
  && scrollkeeper != null && esound != null && gettext != null
  && perlXMLParser != null;

assert teletextSupport -> zvbi != null && zvbi.pngSupport
  /* !!! && pngSupport && zvbi.libpng == libpng */;

assert jpegSupport -> libjpeg != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "zapping-0.7cvs8";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/zapping/zapping-0.7cvs8.tar.bz2;
    md5 = "90324a26025a49916c3c6ae5f1738dfa";
  };

  inherit teletextSupport jpegSupport pngSupport perlXMLParser;

  buildInputs = [
    pkgconfig perl python x11 libXv libXmu libgnomeui
    libglade scrollkeeper esound gettext
    (if teletextSupport then zvbi else null)
    (if jpegSupport then libjpeg else null)
    (if pngSupport then libpng else null)
  ];
}
