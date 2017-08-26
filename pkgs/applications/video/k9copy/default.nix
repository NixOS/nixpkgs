{ stdenv, fetchurl
, cmake, automoc4
, dvdauthor, xineLib, libmpeg2, libav, libdvdread, libdvdnav, dvdplusrwtools
, phonon, qtx11extras
, extra-cmake-modules, kio, kiconthemes, ki18n, kdesu, kdoctools, solid
}:

stdenv.mkDerivation rec {
  version = "3.0.3";
  name = "k9copy-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/k9copy-reloaded/${name}.tar.gz";
    sha256 = "0dp06rwihks50c57bbv04d6bj2qc88isl91971r4lii2xp0qn7sg";
  };

  cmakeFlags = [
    "-DQT5_BUILD=ON"
    "-DCMAKE_MINIMUM_REQUIRED_VERSION=3.0"
  ];

  # Hack to disable documentation
  preConfigure = ''
   substituteInPlace ./CMakeLists.txt \
     --replace "add_subdirectory(doc)" ""
  '';

  buildInputs = [
    cmake
    dvdauthor
    xineLib
    libmpeg2
    libav
    libdvdread
    libdvdnav
    dvdplusrwtools
    #automoc4
    phonon
    extra-cmake-modules
    kio
    solid
    qtx11extras
    kiconthemes
    ki18n
    kdesu
  ];
  nativeBuildInputs = [ kdoctools ];

  meta = {
    description = "DVD backup and DVD authoring program";
    homepage = http://k9copy-reloaded.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ flosse ];
    platforms = stdenv.lib.platforms.unix;
  };
}
