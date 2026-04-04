{
  stdenv,
  lib,
  cmake,
  git,
  fetchFromGitHub,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graphia";
  version = "5.2";

  src = fetchFromGitHub {
    owner = "graphia-app";
    repo = "graphia";
    rev = finalAttrs.version;
    sha256 = "sha256-tS5oqpwpqvWGu67s8OuA4uQR3Zb5VzHTY/GnfVQki6k=";
  };

  nativeBuildInputs = [
    cmake
    git # needs to define some hash as a version
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtwebengine
  ];

  meta = {
    # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/graphia.x86_64-darwin
    broken =
      (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) || stdenv.hostPlatform.isDarwin;
    description = "Visualisation tool for the creation and analysis of graphs";
    homepage = "https://graphia.app";
    license = lib.licenses.gpl3Only;
    mainProgram = "Graphia";
    maintainers = [ lib.maintainers.bgamari ];
    platforms = lib.platforms.all;
  };
})
