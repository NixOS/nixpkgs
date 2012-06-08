{ stdenv, fetchurl, alsaLib, cmake, freetype, jackaudio, libsndfile, pkgconfig, qt4 }:
stdenv.mkDerivation rec {
  version = "1.2";
  name = "musescore-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/mscore/mscore-${version}-nopdf.tar.bz2";
    sha256 = "05h2ika0qyqa5xd03nd45acsfpq8brkd5b4ca4n6n7cljyb0sjrc";
  };

  buildInputs = [ alsaLib cmake freetype libsndfile pkgconfig qt4 jackaudio ];

  # Thanks Gentoo!
  # http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/media-sound/musescore/files/musescore-1.2-cflags.patch
  patches = [ ./musescore-1.2-cflags.patch ];

  preConfigure = ''
    cd mscore
    sed -e "s@/usr/include/freetype2@${freetype}/include/freetype2@" \
      -i mscore/CMakeLists.txt
    
  '';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=RELEASE" ];

  buildPhase = "make -f Makefile";

  # installPhase = ''
  #   make package
  # '';

  meta = with stdenv.lib; {
    description = "Music composition & notation software";
    homepage = http://musescore.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
