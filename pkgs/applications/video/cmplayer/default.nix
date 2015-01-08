{ stdenv, fetchurl, fetchpatch, pkgconfig, python2, perl
, libX11, libxcb, qt5, mesa
, ffmpeg
, libchardet
, mpg123
, libass
, libdvdread
, libdvdnav
, icu
, libquvi
, alsaLib
, libvdpau, libva
, libbluray
, jackSupport ? false, jack ? null
, portaudioSupport ? false, portaudio ? null
, pulseSupport ? true, pulseaudio ? null
, cddaSupport ? false, libcdda ? null
}:

assert jackSupport -> jack != null;
assert portaudioSupport -> portaudio != null;
assert pulseSupport -> pulseaudio != null;
assert cddaSupport -> libcdda != null;

stdenv.mkDerivation rec {
  name = "cmplayer-${version}";
  version = "0.8.16";

  src = fetchurl {
    url = "https://github.com/xylosper/cmplayer/releases/download/v${version}/${name}-source.tar.gz";
    sha256 = "1yppp0jbq3mwa7vq4sjmm2lsqnfcv4n7cjap50gc2bavq7qynr85";
  };

  patches = [ ./fix-gcc48.patch ];

  buildInputs = with stdenv.lib;
                [ libX11 libxcb qt5 mesa
                  ffmpeg
                  libchardet
                  mpg123
                  libass
                  libdvdread
                  libdvdnav
                  icu
                  libquvi
                  alsaLib
                  libvdpau
                  libva
                  libbluray
                ]
                ++ optional jackSupport jack
                ++ optional portaudioSupport portaudio
                ++ optional pulseSupport pulseaudio
                ++ optional cddaSupport libcdda
                ;

  preConfigure = ''
    patchShebangs ./configure
    patchShebangs src/mpv/waf
  '';

  configureFlags = with stdenv.lib;
                   [ "--qmake=qmake" ]
                   ++ optional jackSupport "--enable-jack"
                   ++ optional portaudioSupport "--enable-portaudio"
                   ++ optional pulseSupport "--enable-pulseaudio"
                   ++ optional cddaSupport "--enable-cdda"
                   ;

  preBuild = "patchShebangs ./build-mpv";

  nativeBuildInputs = [ pkgconfig python2 perl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Powerful and easy-to-use multimedia player";
    homepage = http://cmplayer.github.io;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;
  };
}
