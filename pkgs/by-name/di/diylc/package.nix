{
  lib,
  stdenv,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  unzip,
  jdk17,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "diylc";
  version = "5.6.0";

  src = fetchurl {
    url = "https://github.com/bancika/diy-layout-creator/releases/download/v${finalAttrs.version}/diylc-${finalAttrs.version}-universal.zip";
    hash = "sha256-y47md9kaiqpmx+ZNTm5PCHiNMMR9zjsvjc2xpVD6FAk=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    unzip
    makeBinaryWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "diylc";
      desktopName = "DIY Layout Creator";
      comment = "Multi platform circuit layout and schematic drawing tool";
      exec = "diylc";
      icon = "diylc_icon";
      categories = [
        "Development"
        "Electronics"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    # Nope, the icon cannot be named 'diylc' because KDE does not like it.
    install -Dm644 icons/icon_16x16.png $out/share/icons/hicolor/16x16/apps/diylc_icon.png
    install -Dm644 icons/icon_32x32.png $out/share/icons/hicolor/32x32/apps/diylc_icon.png
    install -Dm644 icons/icon_48x48.png $out/share/icons/hicolor/48x48/apps/diylc_icon.png
    install -Dm644 icons/icon_64x64.png $out/share/icons/hicolor/64x64/apps/diylc_icon.png
    install -Dm644 icons/icon_512x512.png $out/share/icons/hicolor/512x512/apps/diylc_icon.png
    install -Dm644 diylc.jar $out/app/diylc/diylc.jar
    install -Dm755 run.sh $out/app/diylc/run.sh
    patchShebangs $out/app/diylc/run.sh
    substituteInPlace $out/app/diylc/run.sh \
      --replace-fail '$(which java)' "${jdk17}/bin/java" \
      --replace-fail "exec java" "exec ${jdk17}/bin/java"
    mkdir $out/bin
    makeWrapper $out/app/diylc/run.sh $out/bin/diylc

    runHook postInstall
  '';

  meta = {
    description = "Multi platform circuit layout and schematic drawing tool";
    mainProgram = "diylc";
    homepage = "https://bancika.github.io/diy-layout-creator";
    changelog = "https://github.com/bancika/diy-layout-creator/releases";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
