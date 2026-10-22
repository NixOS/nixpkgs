{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  expat,
  zlib,
  pkg-config,
  wrapGAppsHook3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "serial-studio";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "Serial-Studio";
    repo = "Serial-Studio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KY7ePFeO29jKnaFbP5IJo1Z/OqldTvmZUGuzZ+yqyK8=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pkg-config
    wrapGAppsHook3 # required for FileChooser
  ];

  buildInputs = [
    expat
    zlib
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

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_ZLIB" true)
    (lib.cmakeBool "USE_SYSTEM_EXPAT" true)
  ];

  patches = [ ./0001-CMake-Deploy-Fix.patch ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/Serial-Studio-GPL3.app $out/Applications
    ln -s $out/Applications/Serial-Studio-GPL3.app/Contents/MacOS/Serial-Studio-GPL3 $out/bin/serial-studio-gpl3
  '';

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Multi-purpose serial data visualization & processing program";
    mainProgram = "serial-studio-gpl3";
    homepage = "https://serial-studio.com/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
