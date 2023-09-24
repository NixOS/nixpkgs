{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libmediainfo, wxGTK32
, desktop-file-utils, libSM, imagemagick, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) Cocoa;
in
stdenv.mkDerivation rec {
  pname = "mediainfo-gui";
  version = "23.07";

  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.xz";
    hash = "sha256-ttfanimZX9NKIhAIJbhD50wyx7xnrbARZrG+7epJ9dA=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ libmediainfo wxGTK32 desktop-file-utils libSM imagemagick ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  sourceRoot = "MediaInfo/Project/GNU/GUI";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Supplies technical and tag information about a video or audio file (GUI version)";
    longDescription = ''
      MediaInfo is a convenient unified display of the most relevant technical
      and tag data for video and audio files.
    '';
    homepage = "https://mediaarea.net/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
    mainProgram = "mediainfo-gui";
  };
}
