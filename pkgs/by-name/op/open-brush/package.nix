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
  pname = "open-brush";
  version = "2.32.0";

  # source build is not worth it for unity based projects
  src = fetchzip {
    url = "https://github.com/icosa-foundation/open-brush/releases/download/${finalAttrs.version}/OpenBrush_Linux_${finalAttrs.version}.zip";
    hash = "sha256-+s5SI4v05VqjwQeShRj62ouJu47XSFLL4y/TnrFh+S4=";
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

    mkdir -p "$out/opt/open-brush"
    cp -r * "$out/opt/open-brush/"
    chmod +x "$out/opt/open-brush/OpenBrush"

    mkdir -p "$out/bin"
    makeWrapper "$out/opt/open-brush/OpenBrush" "$out/bin/open-brush" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.runtimeDependencies}"

    mkdir -p "$out/share/icons/hicolor/128x128/apps"
    ln -s "$out/opt/open-brush/OpenBrush_Data/Resources/UnityPlayer.png" "$out/share/icons/hicolor/128x128/apps/open-brush.png"
    ln -s "$out/bin/open-brush" "$out/bin/OpenBrush"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "open-brush";
      desktopName = "Open Brush";
      comment = finalAttrs.meta.description;
      icon = "open-brush";
      exec = "open-brush";
      categories = [
        "Graphics"
        "3DGraphics"
      ];
      actions = {
        "Monoscopic" = {
          name = "Desktop (Monoscopic) Mode";
          exec = "open-brush --EnableMonoscopicMode";
        };
      };
    })
  ];

  # Has many pre-releases we should only package latest release
  # https://github.com/icosa-foundation/open-brush/releases/latest
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source evolution of Tilt Brush for 3D painting in VR";
    homepage = "https://openbrush.app";
    changelog = "https://github.com/icosa-foundation/open-brush/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ ngi ];
    mainProgram = "open-brush";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
