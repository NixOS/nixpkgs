{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libmediainfo, wxGTK30
, desktop-file-utils, libSM, imagemagick }:

stdenv.mkDerivation rec {
  version = "22.12";
  pname = "mediainfo-gui";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.xz";
    sha256 = "sha256-kyuCc59zjn22A89bsXByBzGp58YdFFwqVKq7PNC3U7w=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libmediainfo wxGTK30 desktop-file-utils libSM imagemagick ];

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
