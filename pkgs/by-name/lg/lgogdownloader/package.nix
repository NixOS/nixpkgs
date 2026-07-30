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
  qt6,
  testers,

  enableGui ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lgogdownloader";
  version = "3.18";

  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dVEV2smZxB6+Utm9FApiFydAS3hLm4y9YZja1B/PiEk=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "set_property(TARGET \''${PROJECT_NAME} PROPERTY CXX_STANDARD 11)" "set_property(TARGET \''${PROJECT_NAME} PROPERTY CXX_STANDARD 17)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    help2man
    html-tidy
  ]
  ++ lib.optional enableGui qt6.wrapQtAppsHook;

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
    qt6.qtbase
    qt6.qtwebengine
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_QT_GUI" enableGui)
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17")
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DJSONCPP_HAS_STRING_VIEW=1")
  ];

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
