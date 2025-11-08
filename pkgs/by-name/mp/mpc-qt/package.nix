{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qt6Packages,
  mpv,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpc-qt";
  version = "24.12.1-flatpak";

  src = fetchFromGitHub {
    owner = "mpc-qt";
    repo = "mpc-qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gn94kVs3Lbd+ggj4jTacHpmnVO2lH/QDhFk+hJC1N/c=";
  };

  nativeBuildInputs = [
    pkg-config
    qt6Packages.qmake
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    mpv
  ];

  postPatch = ''
    substituteInPlace lconvert.pri --replace "qtPrepareTool(LCONVERT, lconvert)" "qtPrepareTool(LCONVERT, lconvert, , , ${qt6Packages.qttools}/bin)"
  '';

  postConfigure = ''
    substituteInPlace Makefile --replace ${qt6Packages.qtbase}/bin/lrelease ${qt6Packages.qttools.dev}/bin/lrelease
  '';

  qmakeFlags = [
    "MPCQT_VERSION=${finalAttrs.version}"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Media Player Classic Qute Theater";
    homepage = "https://mpc-qt.github.io";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [ romildo ];
    mainProgram = "mpc-qt";
  };
})
