{ stdenv, fetchurl, autoreconfHook, pkgconfig, libzen, libmediainfo, wxGTK
, desktop_file_utils, libSM, imagemagick }:

stdenv.mkDerivation rec {
  version = "0.7.83";
  name = "mediainfo-gui-${version}";
  src = fetchurl {
    url = "http://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.xz";
    sha256 = "0d8mph9lbg2lw0ccg1la0kqhbisra8q9rzn195lncch5cia5zyg7";
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
