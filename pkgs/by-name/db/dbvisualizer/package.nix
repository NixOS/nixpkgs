{
  lib,
  makeDesktopItem,
  makeWrapper,
  stdenv,
  temurin-jre-bin-17,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dbvisualizer";
  version = "24.2.2";

  src =
    let
      underscoreVersion = lib.concatStringsSep "_" (lib.splitString "." finalAttrs.version);
    in
    fetchTarball {
      url = "https://www.dbvis.com/product_download/dbvis-${finalAttrs.version}/media/dbvis_linux_${underscoreVersion}.tar.gz";
      sha256 = "sha256:17kbf444n21jawr55w4lr0l216rdjf4w3cykj04i1h2hqbjswvp8";
    };

  nativeBuildInputs = [ makeWrapper ];

  strictDeps = true;

  desktopEntry = makeDesktopItem {
    name = finalAttrs.pname;
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
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -a . $out

    mkdir -p $out/share/
    cp -a ${finalAttrs.desktopEntry}/share/applications $out/share

    mkdir -p $out/share/icons/hicolor/128x128/apps
    ln -s $out/resources/images/tool/dbvis-icon128x128.png \
      $out/share/icons/hicolor/128x128/apps/dbvisualizer.png

    ln -s $out/dbvis $out/bin
    wrapProgram $out/bin/dbvis --set INSTALL4J_JAVA_HOME ${temurin-jre-bin-17}
  '';

  meta = {
    description = "The universal database tool";
    homepage = "https://www.dbvis.com/";
    maintainers = with lib.maintainers; [ boldikoller ];
    license = lib.licenses.unfree;
    mainProgram = "dbvis";
  };
})
