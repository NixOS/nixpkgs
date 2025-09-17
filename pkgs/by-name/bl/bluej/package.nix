{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  unzip,
  openjdk21,
  openjfx21,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  wrapGAppsHook3,
  imagemagick,
  nix-update-script,
}:
let
  openjdk = openjdk21.override {
    enableJavaFX = true;
    openjfx_jdk = openjfx21.override { withWebKit = true; };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bluej";
  version = "5.5.0";

  src = fetchurl {
    url = "https://github.com/k-pet-group/BlueJ-Greenfoot/releases/download/BLUEJ-RELEASE-${finalAttrs.version}/BlueJ-generic-${finalAttrs.version}.jar";
    sha256 = "sha256-UClhTH/9oFfhjYsScBvmD4cKZUJwuAsiyRTiVkPAV0o=";
  };

  unpackPhase = ''
    runHook preUnpack

    unzip -d jar ${finalAttrs.src}
    unzip -d dist jar/bluej-dist.jar

    runHook postUnpack
  '';

  sourceRoot = "dist";

  nativeBuildInputs = [
    wrapGAppsHook3
    copyDesktopItems
    imagemagick
    unzip
  ];
  buildInputs = [
    glib
    gtk3
  ];

  dontWrapGApps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "BlueJ";
      desktopName = "BlueJ";
      exec = "BlueJ";
      icon = "bluej";
      comment = "A simple powerful Java IDE";
      categories = [
        "Application"
        "Development"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib

    cp -r ./lib $out/lib/bluej

    mkdir -p $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256}/apps

    for dimension in 16x16 32x32 48x48 64x64 128x128 256x256; do
      magick convert ./icons/bluej-icon-512-embossed.png -geometry $dimension\
        $out/share/icons/hicolor/$dimension/apps/bluej.png
    done

    makeWrapper ${openjdk}/bin/java $out/bin/bluej \
      "''${gappsWrapperArgs[@]}" \
      --suffix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name}/ \
      --add-flags "-Dawt.useSystemAAFontSettings=on \
                   --add-opens javafx.graphics/com.sun.glass.ui=ALL-UNNAMED \
                   --add-opens javafx.graphics/com.sun.javafx.scene.input=ALL-UNNAMED \
                   -cp $out/lib/bluej/boot.jar bluej.Boot"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple integrated development environment for Java";
    homepage = "https://www.bluej.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = with lib.licenses; [
      gpl2Plus
      classpathException20
    ];
    mainProgram = "bluej";
    maintainers = with lib.maintainers; [ weirdrock ];
    platforms = lib.platforms.linux;
  };

})
