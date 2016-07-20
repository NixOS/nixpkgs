{ stdenv, fetchurl, cmake, kdelibs, automoc4, kdepimlibs, gettext, pkgconfig
, shared_mime_info, perl, boost, gpgme, gmpxx, libalkimia, libofx, libical
, doxygen, aqbanking, gwenhywfar }:

stdenv.mkDerivation rec {
  name = "kmymoney-${version}";
  version = "4.8.0";

  src = fetchurl {
    url = "mirror://kde/stable/kmymoney/${version}/src/${name}.tar.xz";
    sha256 = "1hlayhcmdfayma4hchv2bfyg82ry0h74hg4095d959mg19qkb9n2";
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
