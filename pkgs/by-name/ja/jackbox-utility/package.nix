{ lib
, stdenvNoCC
, fetchurl
, unzip
, makeDesktopItem
, copyDesktopItems
}:

stdenvNoCC.mkDerivation rec {
  pname = "jackbox-utility";
  version = "1.3.7+2";

  src = fetchurl {
    url = "https://github.com/JackboxUtility/JackboxUtility/releases/download/${version}/JackboxUtility_Linux.zip";
    hash = "sha256-Eygy8gIOlD1gLXDtyqGmE6sLM0WLkureZIO43DmWf38=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    unzip
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/pixmaps
    unzip -d $out/bin $src
    cp $out/bin/data/flutter_assets/assets/logo.png $out/share/pixmaps/jackbox-utility.png
    mv $out/bin/JackboxUtility $out/bin/jackbox-utility
    chmod +x $out/bin/jackbox-utility

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "JackboxUtility";
      exec = "jackbox-utility";
      icon = "jackbox-utility";
      comment = meta.description;
      desktopName = "JackboxUtility";
      categories = [ "Game" "Utility" ];
    })
  ];

  meta = with lib; {
    description = "An app to download patches and launch Jackbox games";
    homepage = "https://jackboxutility.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jpeterburs ];
    mainProgram = "jackbox-utility";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
