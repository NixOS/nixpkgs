{
  aria2,
  cmake,
  extraPackages ? [
    aria2
    ffmpeg
    python3
  ],
  fetchFromGitHub,
  ffmpeg,
  lib,
  python3,
  qt6,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "media-downloader";
  version = "5.4.8";

  src = fetchFromGitHub {
    owner = "mhogomchungu";
    repo = "media-downloader";
    rev = finalAttrs.version;
    hash = "sha256-LMgFCoMxLR9Diz0Fqke6J4aQy7cuEN1e7Umpo0/H0Bo=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
  ];

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
