{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  qt5,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "candle";
  version = "10.10.3";

  src = fetchFromGitHub {
    owner = "Denvi";
    repo = "Candle";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-hDrRkFR9CUxGf/FmDZXAFLum6VoAbCtuiuxo1pCT8/E=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [
    qt5.qmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtserialport
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 Candle $out/bin/candle
    runHook postInstall
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "GRBL controller application with G-Code visualizer written in Qt";
    mainProgram = "candle";
    homepage = "https://github.com/Denvi/Candle";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [matti-kariluoma];
    platforms = lib.platforms.linux;
  };
})
