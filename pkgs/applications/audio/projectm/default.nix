{ stdenv, fetchurl, fetchpatch, pkgconfig, cmake
, glew, ftgl, ttf_bitstream_vera
, withQt ? true, qt4
, withLibvisual ? false, libvisual, SDL
, withJack ? false, libjack2
, withPulseAudio ? true, libpulseaudio
}:

assert withJack       -> withQt;
assert withPulseAudio -> withQt;

stdenv.mkDerivation {
  name = "projectm-2.1.0";

  meta = {
    description = "Music Visualizer";
    homepage = "http://projectm.sourceforge.net/";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
  };

  src = fetchurl {
    url = "mirror://sourceforge/projectm/2.1.0/projectM-complete-2.1.0-Source.tar.gz";
    sha256 = "1vh6jk68a0jdb6qwppb6f8cbgmhnv2ba3bcavzfd6sq06gq08cji";
  };

  patch_gcc6 = fetchpatch {
    url = "https://raw.githubusercontent.com/gentoo/gentoo/45abd63abc6644b6e177c057b5b42d894dbf8e29/media-libs/libprojectm/files/libprojectm-2.1.0-fix-c++14.patch";
    sha256 = "1i50scxv1jlqvb3jm3sql89a7wqckxhlpvnhz20vvmm1kii6lrsn";
  };

  patchPhase = ''
    patch -d src/libprojectM -p1 -i "$patch_gcc6"
    sed -i 's:''${LIBVISUAL_PLUGINSDIR}:''${CMAKE_INSTALL_PREFIX}/lib/libvisual-0.4:' \
      src/projectM-libvisual/CMakeLists.txt
  '';

  nativeBuildInputs = [ pkgconfig cmake ];

  cmakeFlags = [
    "-DprojectM_FONT_MENU=${ttf_bitstream_vera}/share/fonts/truetype/VeraMono.ttf"
    "-DprojectM_FONT_TITLE=${ttf_bitstream_vera}/share/fonts/truetype/Vera.ttf"
    "-DINCLUDE-PROJECTM-TEST=OFF"
    "-DINCLUDE-PROJECTM-QT=${if withQt then "ON" else "OFF"}"
    "-DINCLUDE-PROJECTM-LIBVISUAL=${if withLibvisual then "ON" else "OFF"}"
    "-DINCLUDE-PROJECTM-JACK=${if withJack then "ON" else "OFF"}"
    "-DINCLUDE-PROJECTM-PULSEAUDIO=${if withPulseAudio then "ON" else "OFF"}"
  ];

  buildInputs = with stdenv.lib;
    [ glew ftgl ]
    ++ optional withQt qt4
    ++ optionals withLibvisual [ libvisual SDL ]
    ++ optional withJack libjack2
    ++ optional withPulseAudio libpulseaudio
    ;
}
