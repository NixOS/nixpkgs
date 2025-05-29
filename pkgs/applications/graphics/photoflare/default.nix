{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  graphicsmagick,
}:

stdenv.mkDerivation rec {
  pname = "photoflare";
  version = "1.6.13";

  src = fetchFromGitHub {
    owner = "PhotoFlare";
    repo = "photoflare";
    rev = "v${version}";
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

  meta = with lib; {
    description = "Cross-platform image editor with a powerful features and a very friendly graphical user interface";
    mainProgram = "photoflare";
    homepage = "https://photoflare.io";
    maintainers = [ maintainers.omgbebebe ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
