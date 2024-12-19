{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  imagemagick,
  pkg-config,
  qt5,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "converseen";
  version = "0.12.2.4";

  src = fetchFromGitHub {
    owner = "Faster3ck";
    repo = "Converseen";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-+AYw0/hCAVMPeD9MigYO5ddfs6o6w901OJH03H8gYlw=";
  };

  strictDeps = true;

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    imagemagick
    qt5.qtbase
    qt5.qttools
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Batch image converter and resizer";
    homepage = "https://converseen.fasterland.net/";
    changelog = "https://github.com/Faster3ck/Converseen/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "converseen";
    platforms = lib.platforms.all;
  };
})
