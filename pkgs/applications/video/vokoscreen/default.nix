{ stdenv, fetchgit
, pkgconfig, qt5, alsaLib, libv4l, xorg
, ffmpeg
}:

stdenv.mkDerivation {
  name = "vokoscreen-2.5.0";
  src = fetchgit {
    url = "https://github.com/vkohaupt/vokoscreen.git";
    rev = "8325c8658d6e777d34d2e6b8c8bc03f8da9b3d2f";
    sha256 = "1hvw7xz1mj16ishbaip73wddbmgibsz0pad4y586zbarpynss25z";
  };

  buildInputs = [
    alsaLib.dev
    libv4l.dev
    pkgconfig
    qt5.full
    qt5.qmakeHook
    qt5.qtx11extras
    xorg.libXrandr.dev
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
    maintainers = [maintainers.league];
    platforms = platforms.linux;
  };
}
