{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  curl,
  boost,
  liboauth,
  jsoncpp,
  htmlcxx,
  rhash,
  tinyxml-2,
  help2man,
  html-tidy,
  libsForQt5,
  testers,

  enableGui ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lgogdownloader";
  version = "3.17";

  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rERcwPVuioZT4lqw4SUaM0TQIks6ggA5x8fuI+1GAsk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    help2man
    html-tidy
  ]
  ++ lib.optional enableGui libsForQt5.wrapQtAppsHook;

  buildInputs = [
    boost
    curl
    htmlcxx
    jsoncpp
    liboauth
    rhash
    tinyxml-2
  ]
  ++ lib.optionals enableGui [
    libsForQt5.qtbase
    libsForQt5.qtwebengine
  ];

  cmakeFlags = lib.optional enableGui "-DUSE_QT_GUI=ON";

  passthru.tests = {
    version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Unofficial downloader to GOG.com for Linux users. It uses the same API as the official GOGDownloader";
    mainProgram = "lgogdownloader";
    homepage = "https://github.com/Sude-/lgogdownloader";
    license = lib.licenses.wtfpl;
    # qtbase requires a sandbox profile with read access to /usr/share/icu.
    # To prevent build failures in CI, we disable Darwin support when the GUI is enabled.
    platforms = lib.platforms.linux ++ lib.optionals (!enableGui) lib.platforms.darwin;
    maintainers = with lib.maintainers; [ _0x4A6F ];
  };
})
