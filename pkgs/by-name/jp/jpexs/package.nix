{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  makeDesktopItem,
  jdk8,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jpexs";
  version = "24.1.0";

  src = fetchzip {
    url = "https://github.com/jindrapetrik/jpexs-decompiler/releases/download/version${finalAttrs.version}/ffdec_${finalAttrs.version}.zip";
    hash = "sha256-k6cnyiRyU4B5UdsVnY9LpzTO/o7Q9/aRS0Il2jV4PQ0=";
    stripRoot = false;
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/{ffdec,icons/hicolor/512x512/apps}

    cp ffdec.jar $out/share/ffdec
    cp -r lib $out/share/ffdec
    cp icon.png $out/share/icons/hicolor/512x512/apps/ffdec.png
    cp -r ${finalAttrs.desktopItem}/share/applications $out/share

    makeWrapper ${jdk8}/bin/java $out/bin/ffdec \
      --add-flags "-jar $out/share/ffdec/ffdec.jar"
  '';

  desktopItem = makeDesktopItem rec {
    name = "ffdec";
    exec = name;
    icon = name;
    desktopName = "JPEXS Free Flash Decompiler";
    genericName = "Flash Decompiler";
    comment = finalAttrs.meta.description;
    categories = [
      "Development"
      "Java"
    ];
    startupWMClass = "com-jpexs-decompiler-flash-gui-Main";
  };

  meta = {
    description = "Flash SWF decompiler and editor";
    mainProgram = "ffdec";
    longDescription = ''
      Open-source Flash SWF decompiler and editor. Extract resources,
      convert SWF to FLA, edit ActionScript, replace images, sounds,
      texts or fonts.
    '';
    homepage = "https://github.com/jindrapetrik/jpexs-decompiler";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3;
    platforms = jdk8.meta.platforms;
    maintainers = with lib.maintainers; [
      xrtxn
    ];
  };
})
