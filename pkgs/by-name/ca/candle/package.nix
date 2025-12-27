{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  qt5,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "candle";
  version = "10.12";

  src = fetchFromGitHub {
    owner = "Denvi";
    repo = "Candle";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZI9p3FUChE+nuilcKGMgJOO37hTQL6SjA4olxpszSno=";
  };

  cmakeFlags = [ "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/bin" ];

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = with qt5; [
    qtserialport
    qtscript
    qtwebsockets
    qtmultimedia
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GRBL controller application with G-Code visualizer written in Qt";
    mainProgram = "candle";
    homepage = "https://github.com/Denvi/Candle";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ matti-kariluoma ];
    platforms = qt5.qtbase.meta.platforms;
  };
})
