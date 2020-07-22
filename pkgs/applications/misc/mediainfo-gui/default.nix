{ stdenv, fetchurl, autoreconfHook, pkgconfig, libzen, libmediainfo, wxGTK30-gtk3
, desktop-file-utils, libSM, imagemagick }:

stdenv.mkDerivation rec {
  version = "20.03";
  pname = "mediainfo-gui";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.xz";
    sha256 = "1f1shnycf0f1fwka9k9s250l228xjkg0k4k73h8bpld8msighgnw";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libzen libmediainfo wxGTK30-gtk3 desktop-file-utils libSM
                  imagemagick ];

  sourceRoot = "./MediaInfo/Project/GNU/GUI/";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Supplies technical and tag information about a video or audio file (GUI version)";
    longDescription = ''
      MediaInfo is a convenient unified display of the most relevant technical
      and tag data for video and audio files.
    '';
    homepage = "https://mediaarea.net/";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.devhell ];
  };
}
