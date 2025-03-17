{
  lib,
  stdenv,
  fetchFromGitHub,

  # buildInputs
  libXScrnSaver,
  magic-enum,

  # nativeBuildInputs
  qtbase,
  qtconnectivity,
  qtlanguageserver,
  qttools,
  range-v3,
  spdlog,
  qtwayland,

  # nativeBuildInputs
  cmake,
  wrapQtAppsHook,

  # passthru
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kemai";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "AlexandrePTJ";
    repo = "kemai";
    tag = finalAttrs.version;
    hash = "sha256-2Cyrd0fKaEHkDaKF8lFwuoLvl6553rp3ET2xLUUrTnk=";
  };

  buildInputs = [
    libXScrnSaver
    magic-enum
    qtbase
    qtconnectivity
    qtlanguageserver
    qttools
    range-v3
    spdlog
  ] ++ lib.optional stdenv.hostPlatform.isLinux qtwayland;

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "FETCHCONTENT_QUIET" false)
    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Kimai desktop client written in QT6";
    homepage = "https://github.com/AlexandrePTJ/kemai";
    changelog = "https://github.com/AlexandrePTJ/kemai/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ poelzi ];
    platforms = lib.platforms.unix;
    badPlatforms = [ lib.systems.inspect.patterns.isDarwin ];
    mainProgram = "Kemai";
  };
})
