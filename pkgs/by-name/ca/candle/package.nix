{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "candle";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "Denvi";
    repo = "Candle";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-A53rHlabcuw/nWS7jsCyVrP3CUkmUI/UMRqpogyFOCM=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  patches = [
    # Store application settings in ~/.config/Candle
    # https://github.com/Denvi/Candle/pull/658
    ./658.patch
  ];

  patchFlags = [ "-p2" ];

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
