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
  darwin,
  wrapGAppsHook3,
}:

let
  inherit (darwin.apple_sdk.frameworks) Cocoa;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mediainfo-gui";
  version = "24.06";

  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediainfo/${finalAttrs.version}/mediainfo_${finalAttrs.version}.tar.xz";
    hash = "sha256-MvSoKjHjhuF3/fbkwjcFPkdbUBCJJpqyxylFKgkxNSA=";
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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Cocoa ];

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
