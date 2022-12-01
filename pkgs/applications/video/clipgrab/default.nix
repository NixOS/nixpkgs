{ lib, fetchurl, makeDesktopItem, ffmpeg
, qmake, qttools, mkDerivation
, qtbase, qtdeclarative, qtlocation, qtquickcontrols2, qtwebchannel, qtwebengine
, yt-dlp
}:

mkDerivation rec {
  pname = "clipgrab";
  version = "3.9.7";

  src = fetchurl {
    sha256 = "sha256-9H8raJd6MyyFICY8WUZQGLJ4teKPJUiQfqbu1HWAVIw=";
    # The .tar.bz2 "Download" link is a binary blob, the source is the .tar.gz!
    url = "https://download.clipgrab.org/${pname}-${version}.tar.gz";
  };

  buildInputs = [ ffmpeg qtbase qtdeclarative qtlocation qtquickcontrols2 qtwebchannel qtwebengine ];
  nativeBuildInputs = [ qmake qttools ];

  patches = [
    ./yt-dlp-path.patch
  ];

  postPatch = ''
  substituteInPlace youtube_dl.cpp \
    --replace 'QString YoutubeDl::path = QString();' \
              'QString YoutubeDl::path = QString("${yt-dlp}/bin/yt-dlp");'
  '' + lib.optionalString (ffmpeg != null) ''
  substituteInPlace converter_ffmpeg.cpp \
    --replace '"ffmpeg"' '"${ffmpeg.bin}/bin/ffmpeg"' \
    --replace '"ffmpeg ' '"${ffmpeg.bin}/bin/ffmpeg '
  '';

  qmakeFlags = [ "clipgrab.pro" ];

  desktopItem = makeDesktopItem rec {
    name = "clipgrab";
    exec = name;
    icon = name;
    desktopName = "ClipGrab";
    comment = meta.description;
    genericName = "Web video downloader";
    categories = [ "Qt" "AudioVideo" "Audio" "Video" ];
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 clipgrab $out/bin/clipgrab
    install -Dm644 icon.png $out/share/pixmaps/clipgrab.png
    cp -r ${desktopItem}/share/applications $out/share
    runHook postInstall
  '';

  meta = with lib; {
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
