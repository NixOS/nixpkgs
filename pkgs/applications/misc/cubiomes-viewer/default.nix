{ lib
, stdenv
, fetchFromGitHub
, qtbase
, qmake
, wrapQtAppsHook
, copyDesktopItems
, makeDesktopItem
}:

stdenv.mkDerivation rec {
  pname = "cubiomes-viewer";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Cubitect";
    repo = pname;
    rev = version;
    sha256 = "sha256-cIA6W82XEeW0k9WNygZ/KVFZE31QThpkV4OazVEvmtw=";
    fetchSubmodules = true;
  };

  buildInputs = [
    qtbase
  ];

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
    copyDesktopItems
  ];

  desktopItems = [ (makeDesktopItem {
    name = pname;
    desktopName = "Cubiomes Viewer";
    exec = pname;
    icon = pname;
    categories = [ "Game" ];
    comment = meta.description;
  }) ];

  preBuild = ''
    # QMAKE_PRE_LINK is not executed (I dont know why)
    make -C ./cubiomes libcubiomes CFLAGS="-DSTRUCT_CONFIG_OVERRIDE=1" all
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp cubiomes-viewer $out/bin

    mkdir -p $out/share/pixmaps
    cp rc/icons/map.png $out/share/pixmaps/cubiomes-viewer.png

    runHook postInstall
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/Cubitect/cubiomes-viewer";
    description = "A graphical Minecraft seed finder and map viewer";
    longDescription = ''
      Cubiomes Viewer provides a graphical interface for the efficient and flexible seed-finding
      utilities provided by cubiomes and a map viewer for the Minecraft biomes and structure generation.
    '';
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hqurve ];
  };
}
