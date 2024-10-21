{
  alsa-lib,
  autoPatchelfHook,
  copyDesktopItems,
  fetchzip,
  lib,
  libGL,
  libXScrnSaver,
  libXcursor,
  libXi,
  libXinerama,
  libXrandr,
  libXxf86vm,
  libpulseaudio,
  libudev0-shim,
  makeDesktopItem,
  nix-update-script,
  stdenv,
  vulkan-loader,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "daggerfall-unity";
  version = "1.1.1";

  src = fetchzip {
    url = "https://github.com/Interkarma/daggerfall-unity/releases/download/v${finalAttrs.version}/dfu_linux_64bit-v${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-JuhhVLpREM9e9UtlDttvFUhHWpH7Sh79OEo1OM4ggKA=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    alsa-lib
    copyDesktopItems
    libGL
    libXScrnSaver
    libXcursor
    libXi
    libXinerama
    libXrandr
    libXxf86vm
    libpulseaudio
    libudev0-shim
    vulkan-loader
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents "$out"
    cp --recursive * "$out"

    runHook postInstall
  '';

  postFixup = ''
    patchelf \
      --add-needed libEGL.so.1 \
      --add-needed libGL.so.1 \
      --add-needed libGLESv1_CM.so.1 \
      --add-needed libGLESv2.so.2 \
      --add-needed libX11-xcb.so \
      --add-needed libX11.so.6 \
      --add-needed libXcursor.so.1 \
      --add-needed libXext.so.6 \
      --add-needed libXi.so.6 \
      --add-needed libXinerama.so.1 \
      --add-needed libXrandr.so.2 \
      --add-needed libXss.so.1 \
      --add-needed libXxf86vm.so.1 \
      --add-needed libasound.so \
      --add-needed libasound.so.2 \
      --add-needed libc.so.6 \
      --add-needed libdl.so.2 \
      --add-needed libgcc_s.so.1 \
      --add-needed libm.so.6 \
      --add-needed libmonobdwgc-2.0.so \
      --add-needed libpthread.so.0 \
      --add-needed libpulse-simple.so.0 \
      --add-needed librt.so.1 \
      --add-needed libudev.so.0 \
      --add-needed libudev.so.1 \
      --add-needed libvulkan.so.1 \
      "$out/UnityPlayer.so"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "Daggerfall Unity";
      comment = finalAttrs.meta.description;
      icon = "UnityPlayer.png";
      exec = "DaggerfallUnity.x86_64";
      categories = [ "Game" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.dfworkshop.net/";
    description = "Open source recreation of Daggerfall in the Unity engine";
    changelog = "https://github.com/Interkarma/daggerfall-unity/releases/tag/v${finalAttrs.version}";
    mainProgram = "DaggerfallUnity.x86_64";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ l0b0 ];
    platforms = [ "x86_64-linux" ];
  };
})
