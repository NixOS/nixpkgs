{
  fetchzip,
  gitUpdater,
  lib,
  stdenv,
}:

let
  appName = "FlashSpace.app";
  version = "1.2.19";
in
stdenv.mkDerivation {
  pname = "flashspace";

  inherit version;

  src = fetchzip {
    url = "https://github.com/wojciech-kulik/FlashSpace/releases/download/v${version}/FlashSpace.app.zip";
    hash = "sha256-XvEkp9VwJ0twU9pBk+/Ha/rQNmu2CnBjOFpUbAyPf9s=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications/${appName}
    mv Contents $out/Applications/${appName}
    runHook postInstall
  '';

  doInstallCheck = true;

  passthru.updateScript = gitUpdater {
    url = "https://github.com/wojciech-kulik/FlashSpace.git";
    rev-prefix = "v";
  };

  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/wojciech-kulik/FlashSpace";
    description = "Blazingly fast virtual workspace manager for macOS";
    platforms = lib.platforms.darwin;
    maintainers = [ lib.maintainers.marcusramberg ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
