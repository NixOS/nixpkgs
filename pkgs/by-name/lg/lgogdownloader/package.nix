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

  enableGui ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lgogdownloader";
  version = "3.15";

  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-h2N5pRwwZZ3jAvRrT4Ebk4N5WO9tQjDrp8KRqriwUi4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    help2man
    html-tidy
  ] ++ lib.optional enableGui libsForQt5.wrapQtAppsHook;

  buildInputs =
    [
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
    maintainers = with lib.maintainers; [ _0x4A6F ];
    platforms = lib.platforms.linux;
  };
})
