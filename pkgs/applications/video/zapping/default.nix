{ teletextSupport ? true
, jpegSupport ? true
, pngSupport ? true
# !!! libXext shouldn't be necessary (it's in x11); but the builder needs it.
, stdenv, fetchurl, pkgconfig, perl, python, x11, libXv, libXext, libgnomeui
, libglade, scrollkeeper, esound, gettext
, zvbi ? null, libjpeg ? null, libpng ? null }:

assert pkgconfig != null && perl != null && python != null &&
  x11 != null && libXv != null && libgnomeui != null && libglade != null &&
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

  inherit teletextSupport jpegSupport pngSupport libXext;

  buildInputs = [
    pkgconfig perl python x11 libXv libgnomeui
    libglade scrollkeeper esound gettext
    (if teletextSupport then zvbi else null)
    (if jpegSupport then libjpeg else null)
    (if pngSupport then libpng else null)
  ];
}
