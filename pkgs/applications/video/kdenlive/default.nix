{ stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, automoc4, phonon, mlt, gettext
, qimageblitz, qjson, shared_mime_info, soprano }:

stdenv.mkDerivation rec {
  name = "kdenlive-${version}";
  version = "0.8";

  src = fetchurl {
    url = "mirror://sourceforge/kdenlive/${name}.tar.gz";
    sha256 = "18e3390c9eb7124af5cd43819c679374aec46dcaf1fc5cdb43918db470c1076f";
  };

  patches = [ ./kdenlive-newmlt.patch ];

  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon mlt gettext
    qimageblitz qjson shared_mime_info soprano ];

  meta = {
    description = "Free and open source video editor";
    license = "GPLv2+";
    homepage = http://www.kdenlive.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
