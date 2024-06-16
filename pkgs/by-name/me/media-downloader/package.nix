{
  aria2,
  cmake,
  fetchFromGitHub,
  ffmpeg,
  lib,
  libsForQt5,
  python3,
  stdenv,
  yt-dlp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "media-downloader";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "mhogomchungu";
    repo = "media-downloader";
    rev = finalAttrs.version;
    hash = "sha256-ykPYxRgzKZrA0KwS1FoxZOkSL+7TbLgy0yLfs7Iqpf4=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [ libsForQt5.qtbase ];

  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        aria2
        ffmpeg
        python3
        yt-dlp
      ]
    }"
  ];

  meta = {
    description = "Qt/C++ GUI front end for yt-dlp and others";
    homepage = "https://github.com/mhogomchungu/media-downloader";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ zendo ];
    platforms = lib.platforms.linux;
    mainProgram = "media-downloader";
  };
})
