{ stdenv, fetchFromGitHub, mkDerivation
, pkgconfig, qtbase, qttools, qmake, qtmultimedia, qtx11extras, alsaLib, libv4l, libXrandr
, ffmpeg
}:

mkDerivation rec {

  pname = "vokoscreen";
  version = "2.5.8-beta";

  src = fetchFromGitHub {
    owner   = "vkohaupt";
    repo    = "vokoscreen";
    rev     = version;
    sha256  = "1a85vbsi53mhzva49smqwcs61c51wv3ic410nvb9is9nlsbifwan";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [
    alsaLib
    libv4l
    qtbase
    qtmultimedia
    qttools
    qtx11extras
    libXrandr
  ];

  patches = [
    ./ffmpeg-out-of-box.patch
  ];

  preConfigure = ''
    sed -i 's/lrelease-qt5/lrelease/g' vokoscreen.pro
  '';

  postConfigure = ''
    substituteInPlace settings/QvkSettings.cpp --subst-var-by ffmpeg ${ffmpeg}
  '';

  meta = with stdenv.lib; {
    description = "Simple GUI screencast recorder, using ffmpeg";
    homepage = "http://linuxecke.volkoh.de/vokoscreen/vokoscreen.html";
    longDescription = ''
      vokoscreen is an easy to use screencast creator to record
      educational videos, live recordings of browser, installation,
      videoconferences, etc.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.league ];
    platforms = platforms.linux;
  };
}
