{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  cmake,
  extraPackages ? [
    python3
    deno
    ffmpeg
    yt-dlp
    gallery-dl
    you-get
    svtplay-dl
    aria2
    wget
  ],
  python3,
  deno,
  ffmpeg,
  yt-dlp,
  gallery-dl,
  you-get,
  svtplay-dl,
  aria2,
  wget,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "media-downloader";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "mhogomchungu";
    repo = "media-downloader";
    rev = finalAttrs.version;
    hash = "sha256-4mHSBeIbJzTUT24hlLPg1dH69ZNsFWcsReBIP5eu278=";
  };

  postPatch = ''
    substituteInPlace src/settings.cpp \
      --replace-fail 'return this->getOption( "UseSystemEngine",false ) ;' \
                     'return this->getOption( "UseSystemEngine",true ) ;'
  '';

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
