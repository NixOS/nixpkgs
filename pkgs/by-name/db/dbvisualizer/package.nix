{
  lib,
  copyDesktopItems,
  fetchurl,
  makeDesktopItem,
  makeWrapper,
  openjdk17,
  stdenv,
}:

let
  pname = "dbvisualizer";
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  version = "24.2.4";

  src =
    let
      underscoreVersion = builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version;
    in
    fetchurl {
      url = "https://www.dbvis.com/product_download/dbvis-${finalAttrs.version}/media/dbvis_linux_${underscoreVersion}.tar.gz";
      hash = "sha256-vZm8rLkNpnWbKFrH/Q7yMhVhq+zfb0I00hJNT6JaPrw=";
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
    wrapProgram $out/bin/dbvis --set INSTALL4J_JAVA_HOME ${openjdk17}

    runHook postInstall
  '';

  meta = {
    description = "The universal database tool";
    homepage = "https://www.dbvis.com/";
    maintainers = with lib.maintainers; [ boldikoller ];
    license = lib.licenses.unfree;
    mainProgram = "dbvis";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
