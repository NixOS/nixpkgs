{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "serial-studio";
  version = "continuous-unstable-2025-12-17";

  src = fetchFromGitHub {
    owner = "Serial-Studio";
    repo = "Serial-Studio";
    rev = "149b8757fbb1d20e4ae58d5f292900465b51ad10";
    hash = "sha256-ywL4pYvCWPGAUMssCgWqfJn4pTP3/5FKf/lErWIGoWg=";
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
    qt6.qt5compat
  ];

  patches = [ ./0001-CMake-Deploy-Fix.patch ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/Serial-Studio-GPL3.app $out/Applications
    ln --symbolic $out/Applications/Serial-Studio-GPL3.app/Contents/MacOS/Serial-Studio-GPL3 $out/bin/serial-studio
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Multi-purpose serial data visualization & processing program";
    mainProgram = "serial-studio";
    homepage = "https://serial-studio.github.io/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
