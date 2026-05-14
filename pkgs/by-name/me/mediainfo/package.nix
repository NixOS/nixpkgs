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

stdenv.mkDerivation (finalAttrs: {
  pname = "mediainfo";
  version = "26.01";

  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediainfo/${finalAttrs.version}/mediainfo_${finalAttrs.version}.tar.xz";
    hash = "sha256-FQZWytiO9O+k6Cmc/CTZt6cjVFdqaTSZIFiKzuLMPHY=";
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

  meta = {
    description = "Supplies technical and tag information about a video or audio file";
    longDescription = ''
      MediaInfo is a convenient unified display of the most relevant technical
      and tag data for video and audio files.
    '';
    homepage = "https://mediaarea.net/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.devhell ];
    mainProgram = "mediainfo";
  };
})
