{ teletextSupport ? true
, jpegSupport ? true
, pngSupport ? true
, stdenv, fetchurl, pkgconfig, perl, python, x11, libgnomeui
, libglade, scrollkeeper, esound, gettext
, zvbi ? null, libjpeg ? null, libpng ? null }:

assert !isNull pkgconfig && !isNull perl && !isNull python &&
  !isNull x11 && !isNull libgnomeui && !isNull libglade &&
  !isNull scrollkeeper && !isNull esound && !isNull gettext;

assert teletextSupport -> !isNull zvbi && zvbi.pngSupport
  && pngSupport && zvbi.libpng == libpng;

assert jpegSupport -> !isNull libjpeg;
assert pngSupport -> !isNull libpng;

derivation {
  name = "zapping-0.7cvs6";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/zapping/zapping-0.7cvs6.tar.bz2;
    md5 = "cdedc0088c70f4520c37066ec05cb996";
  };

  teletextSupport = teletextSupport;
  jpegSupport = jpegSupport;
  pngSupport = pngSupport;

  stdenv = stdenv;
  pkgconfig = pkgconfig;
  perl = perl;
  python = python;
  x11 = x11;
  libgnomeui = libgnomeui;
  libglade = libglade;
  scrollkeeper = scrollkeeper;
  esound = esound;
  gettext = gettext;
  zvbi = if teletextSupport then zvbi else null;
  libjpeg = if jpegSupport then libjpeg else null;
  libpng = if pngSupport then libpng else null;
}
