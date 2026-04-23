{
  stdenvNoCC,
  lib,
  makeDesktopItem,
  copyDesktopItems,
  fetchurl,
  jdk,
  makeBinaryWrapper,
  imagemagick,
}:

let
  jdkWithFX = jdk.override { enableJavaFX = true; };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jetuml";
  version = "3.9";

  src = fetchurl {
    url = "https://github.com/prmr/JetUML/releases/download/v${finalAttrs.version}/JetUML-${finalAttrs.version}.jar";
    hash = "sha256-wACGbHeRQ5rXcuI1J3eTfQraWp8eWtkIAPo7BNGcFUU=";
  };

  dontUnpack = true;

  strictDeps = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
    imagemagick
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "jetuml";
      desktopName = "JetUML";
      genericName = "UML Tool";
      categories = [
        "Application"
        "Development"
        "ProjectManagement"
      ];
      icon = "jet";
      exec = "jetuml";
      comment = finalAttrs.meta.description;
    })
  ];

  installPhase = ''
    runHook preInstall

    ${jdkWithFX}/lib/openjdk/bin/jar xf $src jet.png
    magick jet.png -resize 128x128 jet128.png
    magick jet.png -resize 48x48 jet48.png
    install -Dm444 jet48.png $out/share/icons/hicolor/48x48/apps/jet.png
    install -Dm444 jet128.png $out/share/icons/hicolor/128x128/apps/jet.png

    install -Dm444 $src $out/share/java/JetUML-${finalAttrs.version}.jar

    makeWrapper ${jdkWithFX}/lib/openjdk/bin/java $out/bin/jetuml \
      --add-flags "-jar $out/share/java/JetUML-${finalAttrs.version}.jar"

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.jetuml.org/";
    description = "Desktop application for fast UML diagramming";
    mainProgram = "jetuml";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.felissedano ];
  };
})
