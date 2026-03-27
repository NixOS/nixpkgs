{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blobdrop";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "vimpostor";
    repo = "blobdrop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o2+qtkyu2qcwXpum3KiogyO8D6aY7bRJ6y4FWQKQY/o=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = [
    qt6.qtdeclarative
    qt6.qtsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6.qtwayland
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  preCheck = ''
    export QT_QPA_PLATFORM=offscreen
  '';

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    changelog = "https://github.com/vimpostor/blobdrop/releases/tag/v${finalAttrs.version}";
    description = "Drag and drop files directly out of the terminal";
    homepage = "https://github.com/vimpostor/blobdrop";
    license = lib.licenses.gpl3Only;
    mainProgram = "blobdrop";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
})
