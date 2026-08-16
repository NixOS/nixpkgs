{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6Packages,
  openal,
  libvorbis,
  libogg,
  libGL,
  libGLU,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dustracing2d";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "juzzlin";
    repo = "DustRacing2D";
    tag = finalAttrs.version;
    hash = "sha256-1+oKSO0pjUBgnlM9J2BB7Xyqbk8liebzUqxKY5M82qg=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
    qt6Packages.qttools
  ];

  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.qtsvg
    qt6Packages.qtwayland
    openal
    libvorbis
    libogg
    libGL
    libGLU
  ];

  cmakeFlags = [
    "-DReleaseBuild=ON"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Top-down 2D racing game with split-screen multiplayer";
    homepage = "https://juzzlin.github.io/DustRacing2D/index.html";
    downloadPage = "https://github.com/juzzlin/DustRacing2D";
    changelog = "https://github.com/juzzlin/DustRacing2D/releases/tag/${finalAttrs.version}";
    mainProgram = "dustrac-game";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
