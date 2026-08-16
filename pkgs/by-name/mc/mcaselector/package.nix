{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
  jre,
}:
let
  version = "2.8";

  jre' = jre.override {
    enableJavaFX = true;
  };

  icon = fetchurl {
    url = "https://github.com/Querz/mcaselector/raw/${version}/installer/linux/icon.png";
    hash = "sha256-nUHTxFHKhp//AL3/B43iXPmp/gcCQPgrEqGAV23U/Vs=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mcaselector";
  inherit version;

  src = fetchurl {
    url = "https://github.com/Querz/mcaselector/releases/download/${finalAttrs.version}/mcaselector-${finalAttrs.version}.jar";
    hash = "sha256-ZFBfOe35ybXUfmZpgfgePDqInU8SKzBlr34mn0jlNCM=";
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    jre'
    makeWrapper
    wrapGAppsHook3
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "mcaselector";
      desktopName = "MCA Selector";
      comment = "Select, edit, and export chunks of your Minecraft world";
      exec = "mcaselector";
      icon = "mcaselector";
      categories = [
        "Game"
        "Java"
      ];
      startupWMClass = "net.querz.mcaselector.ui.Window";
    })
  ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/mcaselector,share/icons/hicolor/512x512/apps}
    cp $src $out/lib/mcaselector/mcaselector.jar
    cp ${icon} $out/share/icons/hicolor/512x512/apps/mcaselector.png

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper ${jre'}/bin/java $out/bin/mcaselector \
      --add-flags "-jar $out/lib/mcaselector/mcaselector.jar" \
      ''${gappsWrapperArgs[@]}
  '';

  meta = {
    homepage = "https://github.com/Querz/mcaselector";
    description = "Tool to select chunks from Minecraft worlds for deletion or export";
    mainProgram = "mcaselector";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Scrumplex ];
    platforms = lib.platforms.linux;
  };
})
