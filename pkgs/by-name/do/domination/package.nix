{
  lib,
  stdenv,
  fetchsvn,
  # jdk8 is needed for building, but the game runs on newer jres as well
  jdk8,
  jre,
  ant,
  stripJavaArchivesHook,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  nixosTests,
}:

let
  desktopItem = makeDesktopItem {
    name = "domination";
    desktopName = "Domination";
    exec = "domination";
    icon = "domination";
  };
  editorDesktopItem = makeDesktopItem {
    name = "domination-map-editor";
    desktopName = "Domination Map Editor";
    exec = "domination-map-editor";
    icon = "domination";
  };

in
stdenv.mkDerivation {
  pname = "domination";
  version = "1.3.1";

  # The .zip releases do not contain the build.xml file
  src = fetchsvn {
    url = "https://svn.code.sf.net/p/domination/code/Domination";
    # There are no tags in the repository.
    # Look for commits like "new version x.y.z info on website"
    # or "website update for x.y.z".
    rev = "2538";
    hash = "sha256-wsLBHkQc1SW+PToyCXIek6qRrRga2nLLkM+5msrnsBo=";
  };

  nativeBuildInputs = [
    jdk8
    ant
    stripJavaArchivesHook
    makeWrapper
    copyDesktopItems
  ];

  buildPhase = ''
    runHook preBuild
    cd swingUI
    ant
    runHook postBuild
  '';

  desktopItems = [
    desktopItem
    editorDesktopItem
  ];

  installPhase = ''
    runHook preInstall
    # Remove unnecessary files and launchers (they'd need to be wrapped anyway)
    rm -r \
      build/game/src.zip \
      build/game/*.sh \
      build/game/*.cmd \
      build/game/*.exe \
      build/game/*.app

    mkdir -p $out/share/domination
    cp -r build/game/* $out/share/domination/

    # Reimplement the two launchers mentioned in Unix_shortcutSpec.xml with makeWrapper
    makeWrapper ${jre}/bin/java $out/bin/domination \
      --chdir "$out/share/domination" \
      --add-flags "-jar $out/share/domination/Domination.jar"
    makeWrapper ${jre}/bin/java $out/bin/domination-map-editor \
      --chdir "$out/share/domination" \
      --add-flags "-cp $out/share/domination/Domination.jar net.yura.domination.ui.swinggui.SwingGUIFrame"

    install -Dm644 build/game/resources/icon.png $out/share/pixmaps/domination.png
    runHook postInstall
  '';

  preFixup = ''
    # remove extra metadata files for jar files which break stripJavaArchivesHook
    find $out/share/domination/lib -type f -name '._*.jar' -delete
  '';

  passthru.tests = {
    domination-starts = nixosTests.domination;
  };

  meta = with lib; {
    homepage = "https://domination.sourceforge.net/";
    downloadPage = "https://domination.sourceforge.net/download.shtml";
    description = "Game that is a bit like the board game Risk or RisiKo";
    longDescription = ''
      Domination is a game that is a bit like the well known board game of Risk
      or RisiKo. It has many game options and includes many maps.
      It includes a map editor, a simple map format, multiplayer network play,
      single player, hotseat, 5 user interfaces and many more features.
    '';
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
    ];
    license = licenses.gpl3Plus;
    mainProgram = "domination";
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
