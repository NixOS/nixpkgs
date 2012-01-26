{ stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, automoc4, phonon, mlt, gettext
, qimageblitz, qjson, shared_mime_info, soprano, pkgconfig }:

stdenv.mkDerivation rec {
  name = "kdenlive-${version}";
  version = "0.8.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/kdenlive/${name}.tar.gz";
    sha256 = "a454a0659c9673453800df8382dfdbcb87acfb9b174712ffeb46b8304bf00717";
  };

  patches = [ ./qtgl-header-change.patch ];

  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon mlt gettext
    qimageblitz qjson shared_mime_info soprano pkgconfig ];

  meta = {
    description = "Free and open source video editor";
    license = "GPLv2+";
    homepage = http://www.kdenlive.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
