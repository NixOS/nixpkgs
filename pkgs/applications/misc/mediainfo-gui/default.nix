{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libmediainfo, wxGTK30-gtk3
, desktop-file-utils, libSM, imagemagick }:

stdenv.mkDerivation rec {
  version = "22.03";
  pname = "mediainfo-gui";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.xz";
    sha256 = "sha256-Yjb5Kh1XqBdLPzDqbd6Kq1ONj2IPcoIk2FE3MWmAK+Q=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libmediainfo wxGTK30-gtk3 desktop-file-utils libSM imagemagick ];

  sourceRoot = "./MediaInfo/Project/GNU/GUI/";

  enableParallelBuilding = true;

  meta = with lib; {
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
