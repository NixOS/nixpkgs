{ stdenv, fetchurl, ffmpeg, makeDesktopItem, qt4 }:

let version = "3.5.2"; in
stdenv.mkDerivation rec {
  name = "clipgrab-${version}";

  src = fetchurl {
    sha256 = "0prag5liwx2l1b2a5f7cp3jh50qw5iwkf2c07iws9m1j1np3lxgp";
    # The .tar.bz2 "Download" link is a binary blob, the source is the .tar.gz!
    url = "http://download.clipgrab.de/${name}.tar.gz";
  };

  meta = with stdenv.lib; {
    inherit version;
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

  buildInputs = [ ffmpeg qt4 ];

  postPatch = stdenv.lib.optionalString (ffmpeg != null) ''
  substituteInPlace converter_ffmpeg.cpp \
    --replace '"ffmpeg"' '"${ffmpeg}/bin/ffmpeg"' \
    --replace '"ffmpeg ' '"${ffmpeg}/bin/ffmpeg '
  '';

  configurePhase = ''
    qmake clipgrab.pro
  '';

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
}
