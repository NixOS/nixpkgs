{
  fetchzip,
  gitUpdater,
  lib,
  stdenv,
}:

let
  appName = "FlashSpace.app";
  version = "2.1.26";
in
stdenv.mkDerivation {
  pname = "flashspace";

  inherit version;

  src = fetchzip {
    url = "https://github.com/wojciech-kulik/FlashSpace/releases/download/v${version}/FlashSpace.app.zip";
    hash = "sha256-szMIg0Iu/H4j7cSpjWZp1Hjf6/gxDt8i5OI2wfkE8BM=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications/${appName}
    mkdir $out/bin
    cp Contents/Resources/flashspace $out/bin
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
