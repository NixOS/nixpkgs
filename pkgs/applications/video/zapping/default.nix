{ stdenv, fetchurl, pkgconfig, perl, python, x11, libgnomeui
, libglade, scrollkeeper, esound, gettext }:

assert !isNull pkgconfig && !isNull perl && !isNull python &&
  !isNull x11 && !isNull libgnomeui && !isNull libglade &&
  !isNull scrollkeeper && !isNull esound && !isNull gettext;

# !!! zvbi library
# !!! arts, jpeg, png, rte

derivation {
  name = "zapping-0.7cvs6";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/zapping/zapping-0.7cvs6.tar.bz2;
    md5 = "cdedc0088c70f4520c37066ec05cb996";
  };

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
}
