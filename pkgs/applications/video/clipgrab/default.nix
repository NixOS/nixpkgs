{ stdenv, fetchurl, qt4 }:

let version = "3.4.9"; in
stdenv.mkDerivation rec {
  name = "clipgrab-${version}";

  src = fetchurl {
    sha256 = "0valq3cgx7yz11zcscz1vdjmppwbicvg0id61dcar22pyp2zkap1";
    url = "http://download.clipgrab.de/${name}.tar.bz2";
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
    license = with licenses; gpl3Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ qt4 ];

  configurePhase = ''
    qmake clipgrab.pro
  '';

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 clipgrab $out/bin

    mkdir -p $out/share
    install -Dm644 icon.png $out/share/pixmaps/clipgrab.png
    install -Dm644 ${./clipgrab.desktop} $out/share/applications/clipgrab.desktop
  '';
}
