{
  lib,
  stdenv,
  fetchFromGitHub,
  gtest,
  cmake,
  pkg-config,
  libchewing,
  qt5,
  qtbase,
  qttools,
}:

stdenv.mkDerivation rec {
  pname = "chewing-editor";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "chewing";
    repo = "chewing-editor";
    tag = version;
    hash = "sha256-gF3OotO/xb3Dc0YjVwAKIYnuEPIrgjpGR2tdjOBT4aI=";
  };

  doCheck = true;

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    gtest
    libchewing
    qtbase
    qttools
  ];

  meta = {
    description = "Cross platform chewing user phrase editor";
    mainProgram = "chewing-editor";
    longDescription = ''
      chewing-editor is a cross platform chewing user phrase editor. It provides a easy way to manage user phrase. With it, user can customize their user phrase to increase input performance.
    '';
    homepage = "https://github.com/chewing/chewing-editor";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
