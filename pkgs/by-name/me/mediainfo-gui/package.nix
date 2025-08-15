{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libmediainfo,
  wxGTK32,
  desktop-file-utils,
  libSM,
  imagemagick,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mediainfo-gui";
  version = "25.07";

  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediainfo/${finalAttrs.version}/mediainfo_${finalAttrs.version}.tar.xz";
    hash = "sha256-UI6sHKCX9Byz/DliWs6wZS/KsArNDy68vR3GgAk26X0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    libmediainfo
    wxGTK32
    desktop-file-utils
    libSM
    imagemagick
  ];

  sourceRoot = "MediaInfo/Project/GNU/GUI";

  enableParallelBuilding = true;

  meta = {
    description = "Supplies technical and tag information about a video or audio file (GUI version)";
    longDescription = ''
      MediaInfo is a convenient unified display of the most relevant technical
      and tag data for video and audio files.
    '';
    homepage = "https://mediaarea.net";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ devhell ];
    mainProgram = "mediainfo-gui";
  };
})
