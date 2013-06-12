{ stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, automoc4, phonon
, mlt, gettext , qimageblitz, qjson, shared_mime_info, soprano
, pkgconfig, shared_desktop_ontologies, libv4l }:

stdenv.mkDerivation rec {
  name = "kdenlive-${version}";
  version = "0.9.6";

  src = fetchurl {
    url = "mirror://kde/stable/kdenlive/${version}/src/${name}.tar.bz2";
    sha256 = "1rw2cbzy5mabwijvryyzbhpgldn2zy5jy4j87hl4m1i8ah9lgi7x";
  };

  buildInputs =
    [ cmake qt4 perl kdelibs automoc4 phonon mlt gettext qimageblitz
      qjson shared_mime_info soprano pkgconfig shared_desktop_ontologies libv4l
    ];

  enableParallelBuilding = true;

  meta = {
    description = "Free and open source video editor";
    license = "GPLv2+";
    homepage = http://www.kdenlive.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
