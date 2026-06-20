{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  graphicsmagick,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "photoflare";
  version = "1.6.13";

  src = fetchFromGitHub {
    owner = "PhotoFlare";
    repo = "photoflare";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-0eAuof/FBro2IKxkJ6JHauW6C96VTPxy7QtfPVzPFi4=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
  ];
  buildInputs = [
    libsForQt5.qtbase
    graphicsmagick
  ];

  qmakeFlags = [ "PREFIX=${placeholder "out"}" ];

  env.NIX_CFLAGS_COMPILE = "-I${graphicsmagick}/include/GraphicsMagick";

  meta = {
    description = "Cross-platform image editor with a powerful features and a very friendly graphical user interface";
    mainProgram = "photoflare";
    homepage = "https://photoflare.io";
    maintainers = [ lib.maintainers.omgbebebe ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
