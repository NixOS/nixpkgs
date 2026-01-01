{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libzen,
  libmediainfo,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "mediainfo";
  version = "25.09";

  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.xz";
    hash = "sha256-jUug2L19QJf9CjiNQTHeQMNaxdvlKkdgt52PHSnvLmM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libzen
    libmediainfo
    zlib
  ];

  sourceRoot = "MediaInfo/Project/GNU/CLI";

  configureFlags = [ "--with-libmediainfo=${libmediainfo}" ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Supplies technical and tag information about a video or audio file";
    longDescription = ''
      MediaInfo is a convenient unified display of the most relevant technical
      and tag data for video and audio files.
    '';
    homepage = "https://mediaarea.net/";
<<<<<<< HEAD
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.devhell ];
=======
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "mediainfo";
  };
}
