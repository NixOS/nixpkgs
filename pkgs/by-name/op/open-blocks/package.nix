{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  alsa-lib,
  dbus,
  libGL,
  libpulseaudio,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  libxscrnsaver,
  libxxf86vm,
  nix-update-script,
  udev,
  vulkan-loader,
  wayland,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open-blocks";
  version = "0.11.0";

  src = fetchzip {
    url = "https://github.com/icosa-foundation/open-blocks/releases/download/${finalAttrs.version}/OpenBlocks_Linux_${finalAttrs.version}.zip";
    hash = "sha256-QUUkKwjE6KyFrjuFAI6ewcACjQFbKFhVrWdpMJ4crwo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  runtimeDependencies = [
    alsa-lib
    dbus
    libGL
    libpulseaudio
    libx11
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

  buildInputs = finalAttrs.runtimeDependencies ++ [
    stdenv.cc.cc.lib
    zlib
  ];

  appendRunpaths = [
    (lib.makeLibraryPath finalAttrs.runtimeDependencies)
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt/open-blocks"
    cp -r * "$out/opt/open-blocks/"
    chmod +x "$out/opt/open-blocks/OpenBlocks"

    mkdir -p "$out/bin"
    makeWrapper "$out/opt/open-blocks/OpenBlocks" "$out/bin/open-blocks" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.runtimeDependencies}"

    mkdir -p "$out/share/icons/hicolor/128x128/apps"
    ln -s "$out/opt/open-blocks/OpenBlocks_Data/Resources/UnityPlayer.png" "$out/share/icons/hicolor/128x128/apps/open-blocks.png"
    ln -s "$out/bin/open-blocks" "$out/bin/OpenBlocks"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "open-blocks";
      desktopName = "Open Blocks";
      comment = finalAttrs.meta.description;
      icon = "open-blocks";
      exec = "open-blocks";
      categories = [
        "Graphics"
        "3DGraphics"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source evolution of Google Blocks for 3D modeling";
    homepage = "https://openblocks.app";
    changelog = "https://github.com/icosa-foundation/open-blocks/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ ngi ];
    mainProgram = "open-blocks";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
