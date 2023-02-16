{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libmediainfo, wxGTK32
, desktop-file-utils, libSM, imagemagick, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) Cocoa;
in
stdenv.mkDerivation rec {
  version = "22.12";
  pname = "mediainfo-gui";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.xz";
    sha256 = "sha256-kyuCc59zjn22A89bsXByBzGp58YdFFwqVKq7PNC3U7w=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libmediainfo wxGTK32 desktop-file-utils libSM imagemagick ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa ];

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
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}
