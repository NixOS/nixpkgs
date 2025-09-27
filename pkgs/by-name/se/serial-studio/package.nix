{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "serial-studio";
  version = "3.1.10";

  src = fetchFromGitHub {
    owner = "Serial-Studio";
    repo = "Serial-Studio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-joAB2Yj1VBfkFWYPt41OX94X+2asd68kfuHRQQMi6og=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtgraphs
    qt6.qtlocation
    qt6.qtconnectivity
    qt6.qttools
    qt6.qtserialport
    qt6.qtpositioning
  ];

  patches = [ ./0001-CMake-Deploy-Fix.patch ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/Serial-Studio-GPL3.app $out/Applications
    ln --symbolic $out/Applications/Serial-Studio-GPL3.app/Contents/MacOS/Serial-Studio-GPL3 $out/bin/serial-studio
  '';

  meta = {
    description = "Multi-purpose serial data visualization & processing program";
    mainProgram = "serial-studio";
    homepage = "https://serial-studio.github.io/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
