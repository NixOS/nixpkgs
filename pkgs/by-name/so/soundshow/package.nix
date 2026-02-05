{
  lib,
  stdenv,
  nix-update-script,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  gtk3,
  zlib,
  alsa-lib,
  dbus,
  libGL,
  libXcursor,
  libXext,
  libXi,
  libXinerama,
  libxkbcommon,
  libXrandr,
  libXScrnSaver,
  libXxf86vm,
  libxcb,
  libX11,
  libXcomposite,
  libXdamage,
  libXfixes,
  udev,
  vulkan-loader,
  wayland,
  makeDesktopItem,
  # Additional dependencies for SoundShowDisplay (CEF/Chromium-based)
  at-spi2-atk,
  at-spi2-core,
  cups,
  expat,
  glib,
  libdrm,
  libxshmfence,
  mesa,
  nspr,
  nss,
  pango,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soundshow";
  version = "2026.02.04";

  src = fetchzip {
    url = "https://github.com/soundshow-app/soundshow-downloads/releases/download/v${finalAttrs.version}/SoundShow-linux-x64.zip";
    hash = "sha256-J0mzP9+SMNNHCXc6kARjlAf/pyOoQr+xSm/UQ6GgUZM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    # Load-time libraries (loaded from DT_NEEDED section in ELF binary)
    alsa-lib
    gtk3
    stdenv.cc.cc.lib
    zlib

    # Run-time libraries (loaded with dlopen)
    dbus
    libGL
    libXcursor
    libXext
    libXi
    libXinerama
    libxkbcommon
    libXrandr
    libXScrnSaver
    libXxf86vm
    udev
    vulkan-loader
    wayland
    libpulseaudio

    # CEF/Chromium dependencies for SoundShowDisplay
    at-spi2-atk
    at-spi2-core
    cups
    expat
    glib
    libdrm
    libxshmfence
    mesa
    nspr
    nss
    pango
    libxcb
    libX11
    libXcomposite
    libXdamage
    libXfixes
  ];

  desktopItem = makeDesktopItem {
    name = "soundshow";
    desktopName = "SoundShow";
    comment = finalAttrs.meta.description;
    icon = "soundshow";
    exec = "soundshow";
    categories = [ "Audio" ];
  };

  installPhase = ''
    runHook preInstall

    # Install main SoundShow application
    # The executable needs UnityPlayer.so and SoundShow_Data in the same directory
    mkdir -p "$out/libexec/soundshow"
    install -Dm755 SoundShow.x86_64 "$out/libexec/soundshow/SoundShow.x86_64"
    install -Dm644 UnityPlayer.so "$out/libexec/soundshow/UnityPlayer.so"
    install -Dm644 libdecor-0.so.0 "$out/libexec/soundshow/libdecor-0.so.0"
    install -Dm644 libdecor-cairo.so "$out/libexec/soundshow/libdecor-cairo.so"
    cp -r SoundShow_Data "$out/libexec/soundshow/"

    # Install SoundShowDisplay application
    mkdir -p "$out/libexec/soundshow-display"
    install -Dm755 Display/SoundShowDisplay.x86_64 "$out/libexec/soundshow-display/SoundShowDisplay.x86_64"
    install -Dm644 Display/UnityPlayer.so "$out/libexec/soundshow-display/UnityPlayer.so"
    install -Dm644 Display/libdecor-0.so.0 "$out/libexec/soundshow-display/libdecor-0.so.0"
    install -Dm644 Display/libdecor-cairo.so "$out/libexec/soundshow-display/libdecor-cairo.so"
    cp -r Display/SoundShowDisplay_Data "$out/libexec/soundshow-display/"

    # Create wrapper scripts
    mkdir -p "$out/bin"
    makeWrapper "$out/libexec/soundshow/SoundShow.x86_64" "$out/bin/soundshow" \
      --chdir "$out/libexec/soundshow"
    makeWrapper "$out/libexec/soundshow-display/SoundShowDisplay.x86_64" "$out/bin/soundshow-display" \
      --chdir "$out/libexec/soundshow-display"

    install -Dm644 "$desktopItem/share/applications/soundshow.desktop" "$out/share/applications/soundshow.desktop"

    runHook postInstall
  '';

  # Patch required run-time libraries as load-time libraries
  #
  # Libraries found with:
  # > strings UnityPlayer.so | grep '\.so'
  postFixup = ''
    # Patch the main SoundShow UnityPlayer.so
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
      "$out/libexec/soundshow/UnityPlayer.so"

    # Patch the SoundShowDisplay UnityPlayer.so
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
      "$out/libexec/soundshow-display/UnityPlayer.so"
  '';

  passthru.updateScript = nix-update-script { };
  meta = with lib; {
    description = "Soundboard and multimedia player for live triggering audio cues";
    homepage = "https://soundshow.app";
    mainProgram = "soundshow";
    license = licenses.unfree;
    maintainers = with lib.maintainers; [
      tunnelmaker
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
