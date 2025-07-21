{
  lib,
  fetchzip,
  makeWrapper,
  openjdk23,
  stdenv,
  copyDesktopItems,
  makeDesktopItem,
  writeShellApplication,
  common-updater-scripts,
  curl,
  gnused,
}:
let
  openjdk = openjdk23.override { enableJavaFX = true; };
in
stdenv.mkDerivation rec {
  pname = "jalbum";
  version = "37.7";

  src = fetchzip {
    url = "https://download.jalbum.net/download/${version}/jAlbum.zip";
    hash = "sha256-kQTBd7WkR6cgUl4Gke9ZcHBtizNS4uYCFaqexpRjLZE=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "jalbum";
      exec = "jalbum";
      icon = "jalbum";
      comment = meta.description;
      genericName = "jalbum";
      desktopName = "JAlbum";
      categories = [ "Graphics" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/jalbum
    cp -r ./* $out/share/jalbum

    mkdir -p $out/share/icons/hicolor/48x48/apps
    ln -s $out/share/jalbum/icons/JalbumApp48.png \
      $out/share/icons/hicolor/48x48/apps/jalbum.png

    makeWrapper ${openjdk}/bin/java $out/bin/jalbum \
      --add-flags "-Xmx8000m \
      --add-exports=java.desktop/sun.awt.shell=ALL-UNNAMED \
      -XX:+UseParallelGC \
      -DmaxSubsampling=2 \
      -DuseDesktop=true \
      -jar $out/share/jalbum/JAlbum.jar"

    runHook postInstall
  '';

  meta = {
    description = "Free Photo Gallery Software for Any Website";
    homepage = "https://jalbum.net";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ silmaril ];
  };

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-jalbum";
    runtimeInputs = [
      curl
      common-updater-scripts
      gnused
    ];
    text = ''
      LATEST_VERSION=$(curl -Lsf https://jalbum.net/en/downloadmirror | sed -n 's!^.*<h1>Download jAlbum \(.*\)</h1>!\1!p')
      update-source-version jalbum "$LATEST_VERSION"
    '';
  });
}
