{ teletextSupport ? true
, jpegSupport ? true
, pngSupport ? true
, stdenv, fetchurl, pkgconfig, perl, python, x11, libgnomeui
, libglade, scrollkeeper, esound, gettext
, zvbi ? null, libjpeg ? null, libpng ? null }:

assert pkgconfig != null && perl != null && python != null &&
  x11 != null && libgnomeui != null && libglade != null &&
  scrollkeeper != null && esound != null && gettext != null;

assert teletextSupport -> zvbi != null && zvbi.pngSupport
  /* !!! && pngSupport && zvbi.libpng == libpng */;

assert jpegSupport -> libjpeg != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "zapping-0.7cvs6";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/zapping/zapping-0.7cvs6.tar.bz2;
    md5 = "cdedc0088c70f4520c37066ec05cb996";
  };

  inherit teletextSupport jpegSupport pngSupport;

  buildInputs = [
    pkgconfig perl python x11 libgnomeui
    libglade scrollkeeper esound gettext
    (if teletextSupport then zvbi else null)
    (if jpegSupport then libjpeg else null)
    (if pngSupport then libpng else null)
  ];
}
