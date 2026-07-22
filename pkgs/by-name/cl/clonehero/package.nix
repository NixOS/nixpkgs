{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  gtk3,
  zlib,
  alsa-lib,
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
  vulkan-loader, # (not used by default, enable in settings menu)
  wayland, # (not used by default, enable with SDL_VIDEODRIVER=wayland - doesn't support HiDPI)
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clonehero";
  version = "1.1.0.6085";

  src = fetchurl {
    url = "https://github.com/clonehero-game/releases/releases/download/v${finalAttrs.version}-final/Linux.x86_64-Standalone.tar";
    hash = "sha256-xy7/3SDNgKw67ikA7CtRVK2gNrfjqx4cTDeRUkkSBKo=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    # Load-time libraries (loaded from DT_NEEDED section in ELF binary)
    alsa-lib
    gtk3
    (lib.getLib stdenv.cc.cc)
    zlib

    # Run-time libraries (loaded with dlopen)
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

  desktopItem = makeDesktopItem {
    name = "clonehero";
    desktopName = "Clone Hero";
    comment = finalAttrs.meta.description;
    icon = "clonehero";
    exec = "clonehero";
    categories = [ "Game" ];
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 clonehero "$out/libexec/clonehero/clonehero"
    install -Dm644 GameAssembly.so "$out/lib/clonehero/GameAssembly.so"
    install -Dm644 UnityPlayer.so "$out/lib/clonehero/UnityPlayer.so"

    mkdir -p "$out/share"
    cp -r clonehero_Data "$out/share/clonehero"
    install -Dm644 "$desktopItem/share/applications/clonehero.desktop" "$out/share/applications/clonehero.desktop"

    mkdir -p "$out/bin" "$out/share/icons/hicolor/128x128/apps"
    ln -s "$out/libexec/clonehero/clonehero" "$out/bin/clonehero"
    ln -s "$out/lib/clonehero/GameAssembly.so" "$out/libexec/clonehero/GameAssembly.so"
    ln -s "$out/lib/clonehero/UnityPlayer.so" "$out/libexec/clonehero/UnityPlayer.so"
    ln -s "$out/share/clonehero" "$out/libexec/clonehero/clonehero_Data"
    ln -s "$out/share/clonehero/Resources/UnityPlayer.png" "$out/share/icons/hicolor/128x128/apps/clonehero.png"

    runHook postInstall
  '';

  # Patch required run-time libraries as load-time libraries
  #
  # Libraries found with:
  # > strings UnityPlayer.so | grep '\.so'
  # and:
  # > LD_DEBUG=libs clonehero
  postFixup = ''
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
      "$out/lib/clonehero/UnityPlayer.so"
  '';

  meta = {
    description = "Clone of Guitar Hero and Rockband-style games";
    homepage = "https://clonehero.net";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      kira-bruneau
      syboxez
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
