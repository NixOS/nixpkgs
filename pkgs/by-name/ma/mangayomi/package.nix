{ lib
, stdenv
, fetchzip

, autoPatchelfHook
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, wrapGAppsHook

, gtk3
, webkitgtk_4_1
, libsoup
, mpv-unwrapped
, xdg-user-dirs
, gnome
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mangayomi";
  version = "0.1.61";

  src = fetchzip {
    url = "https://github.com/kodjodevf/mangayomi/releases/download/v${finalAttrs.version}/Mangayomi-v${finalAttrs.version}-linux.zip";
    hash = "sha256-BdbSiKWPajEYSWzK9dLS6AA8dW3bdnO6mEPVqD78HRE=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
    libsoup
    mpv-unwrapped
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "mangayomi";
      exec = "mangayomi %u";
      icon = "mangayomi";
      desktopName = "Mangayomi";
      comment = finalAttrs.meta.description;
      categories = [ "Utility" ];
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mangayomi
    cp -r * $out/share/mangayomi

    install -Dm644 data/flutter_assets/assets/app_icons/icon-red.png $out/share/pixmaps/mangayomi.png

    makeWrapper $out/share/mangayomi/mangayomi $out/bin/mangayomi \
        --prefix LD_LIBRARY_PATH : $out/share/mangayomi/lib \
        --prefix PATH : ${lib.makeBinPath [ xdg-user-dirs gnome.zenity ]}

    runHook postInstall
  '';

  preFixup = ''
    patchelf $out/share/mangayomi/lib/libmedia_kit_{native_event_loop,video_plugin}.so \
        --replace-needed libmpv.so.1 libmpv.so
  '';

  meta = {
    changelog = "https://github.com/kodjodevf/mangayomi/releases/tag/v${finalAttrs.version}";
    description = "Free and open source application for reading manga and watching anime";
    downloadPage = "https://github.com/kodjodevf/mangayomi/releases";
    homepage = "https://github.com/kodjodevf/mangayomi";
    license = lib.licenses.asl20;
    mainProgram = "mangayomi";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
