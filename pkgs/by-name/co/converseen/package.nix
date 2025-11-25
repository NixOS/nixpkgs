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
  version = "0.15.1.2";

  src = fetchFromGitHub {
    owner = "Faster3ck";
    repo = "Converseen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GHx3mMDhPT3RCcJxu+v63m7Orn6G01hENvWzP/Aqxho=";
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
    maintainers = [ ];
    mainProgram = "converseen";
    platforms = lib.platforms.all;
  };
})
