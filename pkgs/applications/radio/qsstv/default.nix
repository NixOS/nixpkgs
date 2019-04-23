{ stdenv, fetchurl, qtbase, qmake, makeDesktopItem, openjpeg, pkgconfig, fftw,
  libpulseaudio, alsaLib, hamlib, libv4l, fftwFloat }:

stdenv.mkDerivation rec {
  version = "9.2.6";
  name = "qsstv-${version}";

  src = fetchurl {
    url = "http://users.telenet.be/on4qz/qsstv/downloads/qsstv_${version}.tar.gz";
    sha256 = "0sx70yk389fq5djvjwnam6ics5knmg9b5x608bk2sjbfxkila108";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    qmake
    pkgconfig
  ];

  buildInputs = [ qtbase openjpeg fftw libpulseaudio alsaLib hamlib libv4l
                  fftwFloat ];

  desktopItem = makeDesktopItem {
    name = "QSSTV";
    exec = "qsstv";
    icon = "qsstv.png";
    comment = "Qt-based slow-scan TV and fax";
    desktopName = "QSSTV";
    genericName = "qsstv";
    categories = "Application;HamRadio;";
  };

  installPhase = ''
    # Install binary to the right location
    make install INSTALL_ROOT=$out
    mv $out/usr/bin $out/
    rm -r $out/usr

    # Install desktop icon
    install -D qsstv/icons/qsstv.png $out/share/pixmaps/qsstv.png

    # Install desktop item
    cp -rv ${desktopItem}/share $out
  '';

  meta = with stdenv.lib; {
    description = "Qt-based slow-scan TV and fax";
    homepage = http://users.telenet.be/on4qz/;
    platforms = platforms.linux;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ hax404 ];
  };
}

