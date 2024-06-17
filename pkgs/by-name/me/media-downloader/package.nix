{
  aria2,
  cmake,
  # https://github.com/mhogomchungu/media-downloader?tab=readme-ov-file#extensions
  extraPackages ? [
    aria2
    yt-dlp
    ffmpeg
    python3
  ],
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

  # Disable automatically updating extensions when starting the program because this will
  # invalidate the dependence on extensions and may cause potential security issues
  # Can still be enabled in Configure > Actions At Startup
  postPatch = ''
    substituteInPlace src/settings.cpp \
      --replace-fail '"ShowVersionInfoAndAutoDownloadUpdates",true' '"ShowVersionInfoAndAutoDownloadUpdates",false' \
  '';

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [ libsForQt5.qtbase ];

  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath extraPackages}" ];

  meta = {
    description = "Qt/C++ GUI front end for yt-dlp and others";
    longDescription = ''
      Media Downloader is a GUI front end to yt-dlp, youtube-dl, gallery-dl,
      lux, you-get, svtplay-dl, aria2c, wget and safari books.

      Read https://github.com/mhogomchungu/media-downloader/wiki/Extensions
      for further information. We have packaged most of them, and they can
      be added by overriding `extraPackages`.
    '';
    homepage = "https://github.com/mhogomchungu/media-downloader";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      zendo
      aleksana
    ];
    platforms = lib.platforms.linux;
    mainProgram = "media-downloader";
  };
})
