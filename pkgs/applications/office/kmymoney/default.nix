{ stdenv, fetchurl, cmake, kdelibs, automoc4, kdepimlibs, gettext,
  shared_mime_info, perl, boost, gpgme }:

stdenv.mkDerivation rec {
  name = "kmymoney-4.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/kmymoney2/${name}.tar.bz2";
    sha256 = "1yvgyzybfm1ajswwq3w3kdij4y2cyhfkk52xhv7dbp1wrxsp5cx9";
  };

  buildInputs = [ kdelibs kdepimlibs perl boost gpgme ];
  buildNativeInputs = [ cmake automoc4 gettext shared_mime_info ];

  patches = [ ./qgpgme.patch ];

  meta = {
    homepage = http://kmymoney2.sourceforge.net/;
    description = "KDE personal money manager";
    inherit (kdelibs.meta) platforms maintainers;
  };
}
