{ stdenv, fetchurl, makeDesktopItem, ffmpeg, qt4, qmake4Hook }:

stdenv.mkDerivation rec {
  name = "clipgrab-${version}";
  version = "3.5.6";

  src = fetchurl {
    sha256 = "0wm6hqaq6ydbvvd0fqkfydxd5h7gf4di7lvq63xgxl4z40jqc25n";
    # The .tar.bz2 "Download" link is a binary blob, the source is the .tar.gz!
    url = "http://download.clipgrab.de/${name}.tar.gz";
  };

  buildInputs = [ ffmpeg qt4 ];
  nativeBuildInputs = [ qmake4Hook ];

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
    comment = "A friendly downloader for YouTube and other sites";
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
    homepage = http://clipgrab.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
