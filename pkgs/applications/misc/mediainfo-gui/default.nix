{ stdenv, fetchurl, automake, autoconf, libtool, pkgconfig, libzen, libmediainfo, wxGTK, desktop_file_utils, libSM, imagemagick }:

stdenv.mkDerivation rec {
  version = "0.7.77";
  name = "mediainfo-gui-${version}";
  src = fetchurl {
    url = "http://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.xz";
    sha256 = "0n15z1jlj5s69pwk3mdv4r5c8ncfy7qjbdw5wfwynwypkl5382pn";
  };

  buildInputs = [ automake autoconf libtool pkgconfig libzen libmediainfo wxGTK desktop_file_utils libSM imagemagick ];

  sourceRoot = "./MediaInfo/Project/GNU/GUI/";

  preConfigure = "sh autogen.sh";

  meta = {
    description = "Supplies technical and tag information about a video or audio file (GUI version)";
    longDescription = ''
      MediaInfo is a convenient unified display of the most relevant technical
      and tag data for video and audio files.
    '';
    homepage = http://mediaarea.net/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
