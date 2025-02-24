{
  stdenv,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  pkg-config,
  qtbase,
  qttools,
  wrapQtAppsHook,
  enableExperimental ? false,
  includeMatrixDiscovery ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "razergenie";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "z3ntu";
    repo = "RazerGenie";
    rev = "v${finalAttrs.version}";
    sha256 = "17xlv26q8sdbav00wdm043449pg2424l3yaf8fvkc9rrlqkv13a4";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qttools
  ];

  mesonFlags = [
    "-Denable_experimental=${lib.boolToString enableExperimental}"
    "-Dinclude_matrix_discovery=${lib.boolToString includeMatrixDiscovery}"
  ];

  meta = {
    homepage = "https://github.com/z3ntu/RazerGenie";
    description = "Qt application for configuring your Razer devices under GNU/Linux";
    mainProgram = "razergenie";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      f4814n
      Mogria
    ];
    platforms = lib.platforms.linux;
  };
})
