{ stdenv, fetchurl, autoreconfHook, pkgconfig, libzen, libmediainfo, wxGTK
, desktop_file_utils, libSM, imagemagick }:

stdenv.mkDerivation rec {
  version = "0.7.87";
  name = "mediainfo-gui-${version}";
  src = fetchurl {
    url = "http://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.xz";
    sha256 = "1ws4hyfcw289hax0bq8y3bbw5y321xmh0va1x4zv5rjwfzcd51pv";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libzen libmediainfo wxGTK desktop_file_utils libSM
                  imagemagick ];

  sourceRoot = "./MediaInfo/Project/GNU/GUI/";

  meta = with stdenv.lib; {
    description = "Supplies technical and tag information about a video or audio file (GUI version)";
    longDescription = ''
      MediaInfo is a convenient unified display of the most relevant technical
      and tag data for video and audio files.
    '';
    homepage = http://mediaarea.net/;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.devhell ];
  };
}
