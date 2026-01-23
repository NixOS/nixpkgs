{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  hunspell,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "focuswriter";
  version = "1.8.13";

  src = fetchFromGitHub {
    owner = "gottcode";
    repo = "focuswriter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lKhgfFPEcipQcW1S2+ntglVacH6dEcGpnNHvwgeVIzI=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    hunspell
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qt5compat
    qt6.qtwayland
  ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = {
    description = "Simple, distraction-free writing environment";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      madjar
      kashw2
    ];
    platforms = lib.platforms.linux;
    homepage = "https://gottcode.org/focuswriter/";
    mainProgram = "focuswriter";
  };
})
