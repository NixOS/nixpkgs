{ stdenv, fetchurl, makeDesktopItem, ffmpeg
, qmake, qttools, mkDerivation
, qtbase, qtdeclarative, qtlocation, qtquickcontrols2, qtwebchannel, qtwebengine
}:

mkDerivation rec {
  pname = "clipgrab";
  version = "3.8.11";

  src = fetchurl {
    sha256 = "0jpfdmyzjasq4x1xvk7b1cmhhq6fz6ydvvbwz2wclph367x496xk";
    # The .tar.bz2 "Download" link is a binary blob, the source is the .tar.gz!
    url = "https://download.clipgrab.org/${pname}-${version}.tar.gz";
  };

  buildInputs = [ ffmpeg qtbase qtdeclarative qtlocation qtquickcontrols2 qtwebchannel qtwebengine ];
  nativeBuildInputs = [ qmake qttools ];

  postPatch = stdenv.lib.optionalString (ffmpeg != null) ''
  substituteInPlace converter_ffmpeg.cpp \
    --replace '"ffmpeg"' '"${ffmpeg.bin}/bin/ffmpeg"' \
    --replace '"ffmpeg ' '"${ffmpeg.bin}/bin/ffmpeg '
  '';

  qmakeFlags = [ "clipgrab.pro" ];

  enableParallelBuilding = true;

  desktopItem = makeDesktopItem rec {
    name = "clipgrab";
    exec = name;
    icon = name;
    desktopName = "ClipGrab";
    comment = meta.description;
    genericName = "Web video downloader";
    categories = "Qt;AudioVideo;Audio;Video";
  };

  installPhase = ''
    install -Dm755 clipgrab $out/bin/clipgrab
    install -Dm644 icon.png $out/share/pixmaps/clipgrab.png
    cp -r ${desktopItem}/share/applications $out/share
  '';

  meta = with stdenv.lib; {
    description = "Video downloader for YouTube and other sites";
    longDescription = ''
      ClipGrab is a free downloader and converter for YouTube, Vimeo, Metacafe,
      Dailymotion and many other online video sites. It converts downloaded
      videos to MPEG4, MP3 or other formats in just one easy step.
    '';
    homepage = "https://clipgrab.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
