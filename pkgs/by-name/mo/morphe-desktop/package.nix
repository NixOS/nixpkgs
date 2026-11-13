{
  lib,
  stdenvNoCC,
  fetchurl,
  jre,
  libGL,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  unzip,
  imagemagick,
  wrapGAppsHook3,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "morphe-desktop";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/MorpheApp/${finalAttrs.pname}/releases/download/v${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}-all.jar";
    hash = "sha256-Oi7+/VZ7RN3hWXGljVqmSaMqujB4HTQA3AjWiMcgFo8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
    makeWrapper
    unzip
    wrapGAppsHook3
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

    mkdir -p "$out/share/doc/morphe-desktop"

    install -Dm644 "$src" "$out/share/morphe-desktop/morphe-desktop.jar"
    install -Dm644 NOTICE "$out/share/doc/morphe-desktop/NOTICE"

    for size in 16 24 48 64 96 128 256 512; do
      mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/apps"
      magick morphe_logo.png \
        -background none \
        -resize "''${size}x''${size}" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/morphe-desktop.png"
    done

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper ${lib.getExe jre} "$out/bin/morphe-desktop" \
      --add-flags "-jar $out/share/morphe-desktop/morphe-desktop.jar" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]} \
      --set _JAVA_AWT_WM_NONREPARENTING 1 \
      ''${gappsWrapperArgs[@]}

  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--use-github-releases" ];
  };

  meta = {
    description = "Application that patches Android applications";
    homepage = "https://morphe.software";
    changelog = "https://github.com/MorpheApp/morphe-desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = [ lib.maintainers.Nadim147c ];
    mainProgram = "morphe-desktop";
    platforms = lib.platforms.linux;
  };
})
