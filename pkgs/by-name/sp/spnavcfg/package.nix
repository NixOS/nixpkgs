{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libspnav,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spnavcfg";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = "spnavcfg";
    tag = "v${finalAttrs.version}";
    fetchLFS = true;
    hash = "sha256-HYBb1/SgjayJjdA0N8UHPde3y4SugYiWIPP+3Eu3CEI=";
  };

  nativeBuildInputs = [
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    libspnav
  ];

  configureFlags = [
    "--qt6"
    "--qt-tooldir=${qt6.qtbase}/libexec"
  ];

  meta = {
    homepage = "https://spacenav.sourceforge.net/";
    description = "Interactive configuration GUI for space navigator input devices";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "spnavcfg";
  };
})
