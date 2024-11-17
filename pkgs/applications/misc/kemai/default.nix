{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  magic-enum,
  range-v3,
  spdlog,
  qtbase,
  qtconnectivity,
  qttools,
  qtlanguageserver,
  qtwayland,
  wrapQtAppsHook,
  libXScrnSaver,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "kemai";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "AlexandrePTJ";
    repo = "kemai";
    rev = "refs/tags/${version}";
    hash = "sha256-2Cyrd0fKaEHkDaKF8lFwuoLvl6553rp3ET2xLUUrTnk=";
  };

  buildInputs = [
    qtbase
    qtconnectivity
    qttools
    qtlanguageserver
    libXScrnSaver
    magic-enum
    range-v3
    spdlog
  ] ++ lib.optional stdenv.hostPlatform.isLinux qtwayland;
  cmakeFlags = [
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DFETCHCONTENT_QUIET=OFF"
    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS"
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ poelzi ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "Kemai";
  };
}
