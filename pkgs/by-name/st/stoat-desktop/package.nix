{
  stdenvNoCC,
  lib,
  asar,
  fetchurl,
  fetchzip,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron,
}:

stdenvNoCC.mkDerivation rec {
  pname = "stoat-desktop";
  version = "1.1.12";

  src = fetchzip {
    url = "https://github.com/stoatchat/for-desktop/releases/download/v${version}/Stoat-linux-x64-${version}.zip";
    hash = "sha256-S3uJ4ADzDgrpKVxBdEpz73Q6bqOakzk9bObaoRZopbM=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    asar
  ];

  installPhase = ''
    runHook preInstall
    set -euo pipefail

    mkdir -p "$out/bin" "$out/share/applications" "$out/share/stoat-desktop"

    asarPath="$(find "$src" -type f -path '*/resources/app.asar' -print -quit || true)"
    if [ -z "$asarPath" ]; then
      echo "ERROR: could not find resources/app.asar in $src" >&2
      exit 1
    fi

    resDir="$(dirname "$asarPath")"
    appDir="$(dirname "$resDir")"

    cp -a "$resDir" "$out/share/stoat-desktop/resources"
    if [ -d "$appDir/locales" ]; then
      cp -a "$appDir/locales" "$out/share/stoat-desktop/locales"
    fi

    mkdir -p "$out/share/icons/hicolor/scalable/apps"
    install -m644 ${
      fetchurl {
        url = "https://raw.githubusercontent.com/stoatchat/assets/628eb2f8255c215148007f4227d2e0d5d1a67582/desktop/icon.svg";
        hash = "sha256-EMDwnAtfTZqhw8hMGTbMjZUrnVkP+2HkyHlSy6pZmik=";
      }
    } "$out/share/icons/hicolor/scalable/apps/stoat-desktop.svg"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Stoat";
      exec = "stoat-desktop %u";
      icon = "stoat-desktop";
      desktopName = "Stoat";
      genericName = meta.description;
      categories = [
        "Network"
        "Chat"
        "InstantMessaging"
      ];
      startupNotify = false;
    })
  ];

  postFixup = ''
    makeWrapper ${electron}/bin/electron "$out/bin/stoat-desktop" \
      --add-flags "$out/share/stoat-desktop/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

  meta = {
    description = "Open source user-first chat platform";
    homepage = "https://stoat.chat/";
    changelog = "https://github.com/stoatchat/for-desktop/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      heyimnova
      magistau
      v3rm1n0
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "stoat-desktop";
  };
}
