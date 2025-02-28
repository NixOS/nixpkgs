{
  autoPatchelfHook,
  fetchurl,
  gtk3,
  lib,
  makeDesktopItem,
  qt6,
  stdenv,
}:

let
  desktopItem = makeDesktopItem rec {
    type = "Application";
    exec = "roomarranger";
    name = "roomarranger";
    desktopName = "Room Arranger";
    genericName = "Design your room, office, apartment, house.";
    icon = "roomarranger-icon";
    terminal = false;
    categories = [ "Graphics" ];
    mimeTypes = [
      "application/com.roomarranger.project"
      "application/com.roomarranger.object"
    ];
  };
in

stdenv.mkDerivation rec {
  pname = "roomarranger";
  version = "10.0.1";

  src = fetchurl {
    url = "https://f000.backblazeb2.com/file/rooarr/rooarr1001-linux64.tar.gz";
    hash = "sha256-OwJSOfyTQinVKzrJftpFa5NN1kGweBezedpL2aE4LbE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    gtk3
    desktopItem
    qt6.qt3d
    qt6.qtwayland
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp -r rooarr-bin/* $out/lib/

    # Remove bundled dynamic libraries
    rm -f $out/lib/*.so*

    ln -s $out/lib/RoomArranger $out/bin/roomarranger

    # Install desktop entry and icons
    RESOLUTIONS="16x16 32x32 48x48 64x64 128x128 256x256 512x512"
    for res in $RESOLUTIONS; do
      mkdir -p $out/share/icons/hicolor/$res/apps
      cp rooarr-bin/icons/icon_$res.png $out/share/icons/hicolor/$res/apps/roomarranger-icon.png
    done
    mkdir $out/share/icons/hicolor/32x32/mimetypes
    cp rooarr-bin/icons/raFileIcon32.png $out/share/icons/hicolor/32x32/mimetypes/application-com.roomarranger.project.png
    cp rooarr-bin/icons/raFileObjectIcon32.png $out/share/icons/hicolor/32x32/mimetypes/application-com.roomarranger.object.png
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/roomarranger.desktop $out/share/applications/

    runHook postInstall
  '';

  meta = {
    description = "3D room planning software";
    longDescription = ''
      Room Arranger is a 3D room / apartment / floor planner with a simple user interface.
      Free for 30 days. Updates are free.
    '';
    homepage = "https://www.roomarranger.com/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ bellackn ];
    mainProgram = "roomarranger";
    sourceProvenance = [
      lib.sourceTypes.binaryNativeCode
    ];
  };
}
