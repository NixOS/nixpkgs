{
  at-spi2-atk,
  autoPatchelfHook,
  cairo,
  cups,
  fetchurl,
  gdk-pixbuf,
  gtk3,
  lib,
  libGL,
  qt6,
  stdenv,
  xorg,
}:

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
    (lib.getLib stdenv.cc.cc)
  ];

  buildInputs = [
    at-spi2-atk
    cairo
    cups
    gdk-pixbuf
    gtk3
    libGL
    qt6.qt3d
    qt6.qtbase
    qt6.qtwayland
    xorg.libX11
    xorg.libxcb
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
  ];

  unpackPhase = "tar -xzf $src";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp -r rooarr-setup/rooarr-bin/* $out/lib/

    # Remove bundled Qt libraries
    rm -f $out/lib/libQt6*.so*

    # Create a wrapper script to set LD_LIBRARY_PATH correctly
    makeWrapper $out/lib/RoomArranger $out/bin/roomarranger \
    --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}

    runHook postInstall
  '';

  meta = {
    description = "3D room planning software";
    longDescription = ''
      Room Arranger is 3D room / apartment / floor planner with simple user interface.
      Free for 30 days. Updates are free.
    '';
    homepage = "https://www.roomarranger.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bellackn ];
    mainProgram = "roomarranger";
  };
}
