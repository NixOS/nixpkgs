{ stdenv, fetchurl, cmake, kdelibs, automoc4, kdepimlibs, gettext, pkgconfig
, shared_mime_info, perl, boost, gpgme, gmpxx, libalkimia, libofx, libical }:

stdenv.mkDerivation rec {
  name = "kmymoney-4.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/kmymoney2/${name}.tar.bz2";
    sha256 = "0ympq70z0a9zrs623jznj6hnjph2rdhpra0np2mqm1mmy72bkjjz";
  };

  buildInputs = [ kdepimlibs perl boost gpgme gmpxx libalkimia libofx libical ];
  buildNativeInputs = [ cmake automoc4 gettext shared_mime_info pkgconfig ];

  KDEDIRS = libalkimia;

  patches = [ ./qgpgme.patch ];

  meta = {
    homepage = http://kmymoney2.sourceforge.net/;
    description = "KDE personal money manager";
    inherit (kdelibs.meta) platforms maintainers;
  };
}
