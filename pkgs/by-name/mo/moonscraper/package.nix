{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  wrapGAppsHook3,
  autoPatchelfHook,
  buildFHSEnv,
  liberation_ttf,
  alsa-lib,
  gtk2,
  gtk3,
  zlib,
  dbus,
  libGL,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  libxscrnsaver,
  libxxf86vm,
  udev,
  vulkan-loader,
  wayland,
  SDL2,
  makeDesktopItem,
}:
# NOTE: Cf. PKGBUILD[^1] for an example of source build.
# We cannot adopt it until we've packaged Unity.
#
# [^1]: https://raw.githubusercontent.com/FireFox2000000/Moonscraper-Chart-Editor/refs/heads/master/aur/PKGBUILD
let
  # Required because unity uses a hard-coded font path for legacy text boxes (similar to unityhub?)
  fhsEnv = buildFHSEnv {
    name = "moonscraper-fhs-env";
    runScript = "";
    targetPkgs = pkgs: [
      liberation_ttf
      (pkgs.lib.getLib pkgs.ffmpeg_4) # -> avformat.58 is needed when exporting tracks
    ];
  };
in
# heavily inspired by clonehero and yarg packages
stdenv.mkDerivation (finalAttrs: {
  name = "moonscraper";
  version = "1.5.13";

  src = fetchurl {
    url = "https://github.com/FireFox2000000/Moonscraper-Chart-Editor/releases/download/${finalAttrs.version}/Moonscraper.Chart.Editor.v${finalAttrs.version}.Linux.Universal.tar.gz";
    hash = "sha256-/v8gklpLS+bzz/S5FzMo1fZl0ZcHuv3GoNJVlSmDFoc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    gtk2 # libgtk-x11-2.0.so.0
    gtk3
    (lib.getLib stdenv.cc.cc)
    zlib
    SDL2

    dbus
    libGL
    libxcursor
    libxext
    libxi
    libxinerama
    libxkbcommon
    libxrandr
    libxscrnsaver
    libxxf86vm
    udev
    vulkan-loader
    wayland
  ];

  strictDeps = true;
  __structuredAttrs = true;

  desktopItem = makeDesktopItem {
    name = "moonscraper";
    desktopName = "Moonscraper Chart Editor";
    comment = finalAttrs.meta.description;
    icon = "moonscraper";
    exec = "moonscraper";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 'Moonscraper Chart Editor.x86_64' "$out/libexec/moonscraper/Moonscraper Chart Editor.x86_64"

    mkdir -p "$out/share/moonscraper"
    cp -r 'Moonscraper Chart Editor_Data' "$out/share/moonscraper/data"
    cp -r 'Config' "$out/share/moonscraper/config"
    cp -r 'Custom Resources' "$out/share/moonscraper/custom-resources"

    install -Dm644 "$desktopItem/share/applications/moonscraper.desktop" "$out/share/applications/moonscraper.desktop"

    mkdir -p "$out/share/icons/hicolor/128x128/apps"

    ln -s "$out/share/moonscraper/data" "$out/libexec/moonscraper/Moonscraper Chart Editor_Data"
    ln -s "$out/share/moonscraper/config" "$out/libexec/moonscraper/Config"
    ln -s "$out/share/moonscraper/custom-resources" "$out/libexec/moonscraper/Custom Resources"

    ln -s "$out/share/moonscraper/data/Resources/UnityPlayer.png" "$out/share/icons/hicolor/128x128/apps/moonscraper.png"

    makeWrapper ${fhsEnv}/bin/moonscraper-fhs-env "$out/bin/moonscraper" \
      --add-flag "$out/libexec/moonscraper/Moonscraper Chart Editor.x86_64" \
      --argv0 "$out/libexec/moonscraper/Moonscraper Chart Editor.x86_64"

    runHook postInstall
  '';

  preFixup = ''
    patchelf \
      --add-needed libasound.so.2 \
      --add-needed libdbus-1.so.3 \
      --add-needed libGL.so.1 \
      --add-needed libpthread.so.0 \
      --add-needed libudev.so.1 \
      --add-needed libvulkan.so.1 \
      --add-needed libwayland-client.so.0 \
      --add-needed libwayland-cursor.so.0 \
      --add-needed libwayland-egl.so.1 \
      --add-needed libX11.so.6 \
      --add-needed libXcursor.so.1 \
      --add-needed libXext.so.6 \
      --add-needed libXi.so.6 \
      --add-needed libXinerama.so.1 \
      --add-needed libxkbcommon.so.0 \
      --add-needed libXrandr.so.2 \
      --add-needed libXss.so.1 \
      --add-needed libXxf86vm.so.1 \
      --add-needed libSDL2.so \
      "$out/libexec/moonscraper/Moonscraper Chart Editor.x86_64"
  '';

  meta = {
    description = "A song editor for Guitar Hero style rhythm games";
    maintainers = [ lib.maintainers.lajp ];
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
