{
  lib,
  stdenvNoCC,
  fetchurl,
  jre,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  unzip,
  imagemagick,
  wrapGAppsHook3,
  fontconfig,
  libGL,
}:

let
  dependencies = lib.importJSON ./deps.json;
  dependenciesJars = map fetchurl (lib.attrValues dependencies.${stdenvNoCC.hostPlatform.system});
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "morphe-desktop";
  version = "2.4.0";

  src = fetchurl {
    url = "https://github.com/MorpheApp/morphe-desktop/releases/download/v${finalAttrs.version}/morphe-desktop-${finalAttrs.version}-all.jar";
    hash = "sha256-1fdcBebIRzHcGPqmWIEKPtSasy1gt1bahQNDLnjPFHc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
    unzip
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    fontconfig
    libGL
  ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Morphe Desktop";
      genericName = "Android software patcher";
      name = "morphe-desktop";
      exec = "morphe-desktop";
      icon = "morphe-desktop";
      categories = [ "Utility" ];
      terminal = false;
      startupWMClass = "Morphe";
    })
  ];
  dontWrapGApps = true;

  unpackPhase = ''
    runHook preUnpack
    unzip $src NOTICE morphe_logo.png
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 "$src" "$out/share/morphe-desktop/morphe-desktop.jar"
    for jar in ${lib.escapeShellArgs dependenciesJars}; do
      ln -s "$jar" "$out/share/morphe-desktop/$(stripHash "$jar")"
    done
    install -Dm644 NOTICE "$out/share/doc/morphe-desktop/NOTICE"

    for size in 16 24 48 64 96 128 256; do
      mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/apps"
      magick morphe_logo.png \
        -background none \
        -resize "''${size}x''${size}" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/morphe-desktop.png"
    done

    runHook postInstall
  '';

  preFixup = ''
    jars=$(printf "%s:" $out/share/morphe-desktop/*)
    makeWrapper ${lib.getExe jre} "$out/bin/morphe-desktop" \
      --add-flags "-cp ''${jars%:}" \
      --add-flags 'app.morphe.MorpheLauncherKt' \
      --add-flags '--internal-gui-subprocess' \
      --set _JAVA_AWT_WM_NONREPARENTING 1 \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs} \
      "''${gappsWrapperArgs[@]}"

    makeWrapper ${lib.getExe jre} "$out/bin/morphe-cli" \
      --add-flags "-jar $out/share/morphe-desktop/morphe-desktop.jar" \
      --run ${lib.escapeShellArg ''
        if [[ "$#" -eq 0 ]]; then
          exec ${placeholder "out"}/bin/morphe-cli --help
        fi
      ''}
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Application that patches Android applications";
    homepage = "https://morphe.software";
    changelog = "https://github.com/MorpheApp/morphe-desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [
      lib.sourceTypes.binaryBytecode
      lib.sourceTypes.binaryNativeCode
    ];
    maintainers = [ lib.maintainers.Nadim147c ];
    mainProgram = "morphe-desktop";
    platforms = lib.intersectLists lib.platforms.linux (lib.attrNames dependencies);
  };
})
