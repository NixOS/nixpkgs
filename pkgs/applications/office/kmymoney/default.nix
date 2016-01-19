{ stdenv, fetchurl, cmake, kdelibs, automoc4, kdepimlibs, gettext, pkgconfig
, shared_mime_info, perl, boost, gpgme, gmpxx, libalkimia, libofx, libical
, doxygen, aqbanking, gwenhywfar }:

stdenv.mkDerivation rec {
  name = "kmymoney-4.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/kmymoney2/${name}.tar.xz";
    sha256 = "0g9rakjx7zmw4bf7m5516rrx0n3bl2by3nn24iiz9209yfgw5cmz";
  };

  cmakeFlags = [
    "-DENABLE_KBANKING='true'"
  ];

  buildInputs = [ kdepimlibs perl boost gpgme gmpxx libalkimia libofx libical
                  doxygen aqbanking gwenhywfar ];
  nativeBuildInputs = [ cmake automoc4 gettext shared_mime_info pkgconfig ];

  KDEDIRS = libalkimia;

  patches = [ ./qgpgme.patch ];

  meta = {
    homepage = http://kmymoney2.sourceforge.net/;
    description = "KDE personal money manager";
    inherit (kdelibs.meta) platforms maintainers;
  };
}
