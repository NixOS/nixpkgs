{ stdenv, fetchurl, cmake, kdelibs, automoc4, kdepimlibs, gettext, pkgconfig
, shared_mime_info, perl, boost, gpgme, gmpxx, libalkimia, libofx, libical
, doxygen }:

stdenv.mkDerivation rec {
  name = "kmymoney-4.6.4";

  src = fetchurl {
    url = "mirror://sourceforge/kmymoney2/${name}.tar.xz";
    sha256 = "04n0lgi2yrx67bgjzbdbcm10pxs7l53srmp240znzw59njnjyll9";
  };

  buildInputs = [ kdepimlibs perl boost gpgme gmpxx libalkimia libofx libical
                  doxygen ];
  nativeBuildInputs = [ cmake automoc4 gettext shared_mime_info pkgconfig ];

  KDEDIRS = libalkimia;

  patches = [ ./qgpgme.patch ];

  meta = {
    homepage = http://kmymoney2.sourceforge.net/;
    description = "KDE personal money manager";
    inherit (kdelibs.meta) platforms maintainers;
  };
}
