{ aria2
, cmake
, fetchFromGitHub
, ffmpeg
, lib
, python3
, qtbase
, stdenv
, wrapQtAppsHook
, yt-dlp
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "media-downloader";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "mhogomchungu";
    repo = "media-downloader";
    rev = finalAttrs.version;
    hash = "sha256-ucANfu28Co88btr4YEBENuxkOOTL/9V5JdN8cRq944Q=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [
        aria2
        ffmpeg
        python3
        yt-dlp
      ]}"
  ];

  meta = {
    description = "A Qt/C++ GUI front end for yt-dlp and others";
    homepage = "https://github.com/mhogomchungu/media-downloader";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ zendo ];
    platforms = lib.platforms.linux;
  };
})
