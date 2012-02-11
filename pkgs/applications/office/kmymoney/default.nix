{ stdenv, fetchurl, cmake, kdelibs, automoc4, kdepimlibs, gettext, pkgconfig
, shared_mime_info, perl, boost, gpgme, gmpxx, libalkimia, libofx, libical }:

stdenv.mkDerivation rec {
  name = "kmymoney-4.6.2";

  src = fetchurl {
    url = "mirror://sourceforge/kmymoney2/${name}.tar.bz2";
    sha256 = "0x9bl4h2mk8dv49nnn7drv528fnl5ynvvyy7q4m22k0d5yxarn5d";
  };

  buildInputs = [ kdepimlibs perl boost gpgme gmpxx libalkimia libofx libical ];
  buildNativeInputs = [ cmake automoc4 gettext shared_mime_info pkgconfig ];

  KDEDIRS = libalkimia;

  patches = [ ./qgpgme.patch ./qt-4.8.patch ];

  meta = {
    homepage = http://kmymoney2.sourceforge.net/;
    description = "KDE personal money manager";
    inherit (kdelibs.meta) platforms maintainers;
  };
}
