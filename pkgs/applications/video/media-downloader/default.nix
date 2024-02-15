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
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "mhogomchungu";
    repo = "media-downloader";
    rev = finalAttrs.version;
    hash = "sha256-hQLrs4RyHUtcG03h0nCn3uMsHEskGKMVwUkcssGZQLs=";
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
    mainProgram = "media-downloader";
  };
})
