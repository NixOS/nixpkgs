{
  lib,
  stdenv,
  fetchFromGitHub,

  # buildInputs
  libxscrnsaver,
  magic-enum,
  qt6,
  range-v3,
  spdlog,

  # nativeBuildInputs
  cmake,

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

  postPatch = ''
    substituteInPlace \
      src/client/parser.cpp \
      src/client/kimaiCache.cpp \
      --replace-fail \
        "#include <magic_enum.hpp>" \
        "#include <magic_enum/magic_enum.hpp>"
  '';

  buildInputs = [
    libxscrnsaver
    magic-enum
    qt6.qtbase
    qt6.qtconnectivity
    qt6.qtlanguageserver
    qt6.qttools
    range-v3
    spdlog
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux qt6.qtwayland;

  cmakeFlags = [
    (lib.cmakeBool "KEMAI_ENABLE_UPDATE_CHECK" false)
    (lib.cmakeBool "KEMAI_BUILD_LOCAL_DEPENDENCIES" false)
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Kimai desktop client written in QT6";
    homepage = "https://github.com/AlexandrePTJ/kemai";
    changelog = "https://github.com/AlexandrePTJ/kemai/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ poelzi ];
    platforms = lib.platforms.unix;
    badPlatforms = [ lib.systems.inspect.patterns.isDarwin ];
    mainProgram = "Kemai";
  };
})
