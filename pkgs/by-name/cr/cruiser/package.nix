{
  stdenvNoCC,
  lib,
  fetchzip,
  jre,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cruiser";
  version = "5.6.2";

  src = fetchzip {
    url = "https://github.com/devemux86/cruiser/releases/download/${finalAttrs.version}/cruiser-${finalAttrs.version}.zip";
    hash = "sha256-uUrHRc/Wd9/B5VFTr22W/wRxgz9hTryI97B2SnJo4HI=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Cruiser";
      exec = "cruiser";
      icon = "cruiser";
      desktopName = "Cruiser";
      genericName = "Map and Navigation";
      categories = [
        "Application"
        "Maps"
      ];
      comment = "Map and navigation application using offline vector maps";
      startupWMClass = "Cruiser";
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/java

    cp -r $src/lib $src/cruiser.jar $out/share/java

    makeWrapper ${lib.getExe jre} $out/bin/cruiser \
      --add-flags "-jar $out/share/java/cruiser.jar"

    # install icon
    mkdir -p $out/share/icons/hicolor/512x512/apps/
    cp $src/cruiser.png $out/share/icons/hicolor/512x512

    runHook postInstall
  '';

  meta = {
    description = "Offline route planning and navigation application";
    homepage = "https://github.com/devemux86/cruiser";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ kilianar ];
    platforms = lib.platforms.linux;
    mainProgram = "cruiser";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
})
