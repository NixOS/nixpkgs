{ stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, automoc4, phonon
, mlt, gettext , qimageblitz, qjson, shared_mime_info, soprano
, pkgconfig, shared_desktop_ontologies }:

stdenv.mkDerivation rec {
  name = "kdenlive-${version}";
  version = "0.9.4";

  src = fetchurl {
    url = "mirror://kde/stable/kdenlive/${version}/src/${name}.tar.bz2";
    sha256 = "1l3axf3y83gdfr6yc1lmy296h09gypkpqsc01w7pprg0y19rrfif";
  };

  buildInputs = 
    [ cmake qt4 perl kdelibs automoc4 phonon mlt gettext qimageblitz
      qjson shared_mime_info soprano pkgconfig shared_desktop_ontologies
    ];

  meta = {
    description = "Free and open source video editor";
    license = "GPLv2+";
    homepage = http://www.kdenlive.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
