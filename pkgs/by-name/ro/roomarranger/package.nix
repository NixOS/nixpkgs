{
  autoPatchelfHook,
  copyDesktopItems,
  fetchurl,
  gtk3,
  lib,
  makeDesktopItem,
  qt6,
  stdenv,
}:

let
  desktopItem = makeDesktopItem {
    type = "Application";
    exec = "roomarranger";
    name = "roomarranger";
    desktopName = "Room Arranger";
    genericName = "Design your room, office, apartment or house, plan gardens and more...";
    icon = "roomarranger-icon";
    terminal = false;
    categories = [ "Graphics" ];
    mimeTypes = [
      "application/com.roomarranger.project"
      "application/com.roomarranger.object"
    ];
  };
in

stdenv.mkDerivation {
  pname = "roomarranger";
  version = "10.2";

  src = fetchurl {
    url = "https://f000.backblazeb2.com/file/rooarr/rooarr1020-linux64.tar.gz";
    hash = "sha256-24AGP2le5HfcVMlqDjiMRcRWKU/zjACV7KzJlVWMpkw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    gtk3
    qt6.qt3d
    qt6.qtwayland
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp -r rooarr-bin/* $out/lib/

    ln -s $out/lib/RoomArranger $out/bin/roomarranger

    # Install application icons
    icon_resolutions="16x16 32x32 48x48 64x64 128x128 256x256 512x512"
    for res in $icon_resolutions; do
      mkdir -p $out/share/icons/hicolor/$res/apps
      cp rooarr-bin/icons/icon_$res.png $out/share/icons/hicolor/$res/apps/roomarranger-icon.png
    done
    mkdir -p $out/share/icons/hicolor/32x32/mimetypes
    cp rooarr-bin/icons/raFileIcon32.png $out/share/icons/hicolor/32x32/mimetypes/application-com.roomarranger.project.png
    cp rooarr-bin/icons/raFileObjectIcon32.png $out/share/icons/hicolor/32x32/mimetypes/application-com.roomarranger.object.png

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  meta = {
    description = "3D room planning software";
    longDescription = ''
      Room Arranger is a 3D room / apartment / floor planner with a simple user interface.
      Free for 30 days. Updates are free.
    '';
    homepage = "https://www.roomarranger.com/";
    changelog = "https://www.roomarranger.com/whatsnew.txt";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ bellackn ];
    mainProgram = "roomarranger";
    sourceProvenance = [
      lib.sourceTypes.binaryNativeCode
    ];
  };
}
