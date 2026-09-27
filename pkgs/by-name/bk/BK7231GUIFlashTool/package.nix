{
  lib,
  stdenv,
  fetchFromGitHub,
  mono,
  gtk2,
  imagemagick,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "BK7231GUIFlashTool";
  version = "50";

  src = fetchFromGitHub {
    owner = "openshwprojects";
    repo = "BK7231GUIFlashTool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ssL5hX64maAl9qrJ08nUGfEWWLGfWbyv8St5WD4If2Y=";
  };

  nativeBuildInputs = [
    mono
    imagemagick
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    gtk2
  ];

  buildPhase = ''
    runHook preBuild
    xbuild BK7231Flasher.sln /p:Configuration=Release
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/lib/BK7231GUIFlashTool
    cp -r BK7231Flasher/bin/Release/* $out/lib/BK7231GUIFlashTool/
    makeWrapper ${mono}/bin/mono $out/bin/BK7231Flasher \
      --add-flags "$out/lib/BK7231GUIFlashTool/BK7231Flasher.exe" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gtk2 ]}"
    runHook postInstall
  '';

  meta = {
    description = "GUI flashing tool for BK7231 chips used in smart home devices";
    longDescription = ''
      BK7231 GUI Flash Tool a simple Windows application that allows you to flash the
      OpenBK firmware to Beken chipset (BK7231T or BK7231N, can also flash BK7231M,
      BL2028N and BK7238) based devices without having extensive programming knowledge.
    '';
    homepage = "https://github.com/openshwprojects/BK7231GUIFlashTool";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ritiek ];
    platforms = lib.platforms.linux;
    mainProgram = "BK7231Flasher";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "BK7231Flasher";
      exec = "BK7231Flasher";
      icon = "BK7231GUIFlashTool";
      desktopName = "BK7231Flasher";
      genericName = "GUI flashing tool for BK7231 chips";
      categories = [
        "Development"
        "Electronics"
      ];
      comment = finalAttrs.meta.description;
    })
  ];

  postInstall = ''
    ICO_SOURCE="BK7231Flasher/bk_icon.ico"
    ICO_DIR="$out/share/icons/hicolor"

    for size in 16 24 32 48 64 128 256; do
      ICON_DIR="$ICO_DIR/''${size}x''${size}/apps"
      mkdir -p "$ICON_DIR"
      magick "$ICO_SOURCE" -resize "''${size}x''${size}" "$ICON_DIR/BK7231GUIFlashTool.png"
    done

    mkdir -p "$out/share/pixmaps"
    cp "$ICO_SOURCE" "$out/share/pixmaps/BK7231GUIFlashTool.ico"
  '';
})
