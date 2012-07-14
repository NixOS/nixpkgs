{ stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, automoc4, phonon
, mlt, gettext , qimageblitz, qjson, shared_mime_info, soprano
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "kdenlive-${version}";
  version = "0.9.2";

  src = fetchurl {
    url = "mirror://kde/stable/kdenlive/0.9.2/src/${name}.tar.bz2";
    sha256 = "1h240s0c10z8sgvwmrfzam33qlx7j2a5b12lw1mk02ihs9hl43j1";
  };

  buildInputs = 
    [ cmake qt4 perl kdelibs automoc4 phonon mlt gettext qimageblitz
      qjson shared_mime_info soprano pkgconfig 
    ];

  meta = {
    description = "Free and open source video editor";
    license = "GPLv2+";
    homepage = http://www.kdenlive.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
