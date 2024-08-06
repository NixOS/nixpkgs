{
  aria2,
  cmake,
  # https://github.com/mhogomchungu/media-downloader?tab=readme-ov-file#extensions
  extraPackages ? [
    aria2
    ffmpeg
    python3
  ],
  fetchFromGitHub,
  ffmpeg,
  lib,
  libsForQt5,
  python3,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "media-downloader";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "mhogomchungu";
    repo = "media-downloader";
    rev = finalAttrs.version;
    hash = "sha256-ERH/lQv+ykJ0gfJBkwGUeFXenoALr2rf7Vm+ZAn23fg=";
  };

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
      for further information. Note that adding these packages to extraPackages
      doesn't work, because the author doesn't intend to support custom
      installation of them. These packages will be downloaded from original
      source when executing the application for the first time.
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
