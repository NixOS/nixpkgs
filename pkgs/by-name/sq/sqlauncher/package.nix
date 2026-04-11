{
  stdenv,
  fetchFromCodeberg,
  cmake,
  ninja,
  qt6,
  lib,
}:

stdenv.mkDerivation {
  pname = "sqlauncher";
  version = "0.0.0-unstable-2025-12-30";

  src = fetchFromCodeberg {
    owner = "ItsZariep";
    repo = "SQLauncher";
    rev = "4a82d0f5d1394f3ff850297939b62357f7f3ce0f";
    hash = "sha256-9yMdJn+aMJQrkreEWkaTw0ZAtmNtTw50n2pXu3d9m6w=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    cmake
    ninja
  ];
  buildInputs = [
    qt6.qtbase
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp sqlauncher $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Simple QT6 Program Launcher";
    homepage = "https://codeberg.org/ItsZariep/SQLauncher";
    license = lib.licenses.gpl3Only;
    mainProgram = "sqlauncher";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.reylak ];
  };
}
