{
  lib,
  copyDesktopItems,
  fetchurl,
  makeDesktopItem,
  makeWrapper,
  openjdk25,
  stdenv,
}:

# nixpkgs-update: no auto update
# NOTE: Do not update to interim patch versions. The download URL will get shut
# down after a while. Dbvisualizer discontinues download
# URLs for all but the last patch version per minor version.
# Example: v25.3.2 gets shut down after v25.3.3 gets released.

let
  pname = "dbvisualizer";
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  version = "26.1.3";

  src =
    let
      underscoreVersion = builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version;
    in
    fetchurl {
      url = "https://www.dbvis.com/product_download/dbvis-${finalAttrs.version}/media/dbvis_linux_${underscoreVersion}.tar.gz";
      hash = "sha256-ifD6pNWsw0n+aiPvQXG0pjNp/NMIAbr+bxzzntDahhs=";
    };

  strictDeps = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "DB Visualizer";
      tryExec = "dbvis";
      exec = "dbvis";
      icon = "dbvisualizer";
      categories = [ "Development" ];
      terminal = false;
      keywords = [
        "Database"
        "SQL"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -a . $out

    mkdir -p $out/share/icons/hicolor/128x128/apps
    ln -s $out/resources/images/tool/dbvis-icon128x128.png \
      $out/share/icons/hicolor/128x128/apps/dbvisualizer.png

    ln -s $out/dbvis $out/bin/
    wrapProgram $out/bin/dbvis --set INSTALL4J_JAVA_HOME ${openjdk25}

    runHook postInstall
  '';

  meta = {
    description = "Universal database tool";
    homepage = "https://www.dbvis.com/";
    maintainers = with lib.maintainers; [ boldikoller ];
    license = lib.licenses.unfree;
    mainProgram = "dbvis";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
