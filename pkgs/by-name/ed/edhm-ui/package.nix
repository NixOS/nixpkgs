# Elite Dangerous HUD Mod UI - GUI for managing HUD color modifications
# Note: Includes standard redistributable DLLs (Microsoft DirectX, NVIDIA API)
# - Analysis confirms these are unmodified redistributable components
# - Explicit redistribution permission granted by EDHM copyright holder
{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  unzip,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  cups,
  dbus,
  glib,
  gtk3,
  libgbm,
  libglvnd,
  nss,
  vivaldi-ffmpeg-codecs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "edhm-ui";
  version = "3.0.62";

  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/BlueMystical/EDHM_UI/releases/download/v${finalAttrs.version}/edhm-ui-v3-linux-x64.zip";
    hash = "sha256-Y5t1HRcplxdx1luBRq/INOu0wbZQZekpfK9zdWVfC8k=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cups
    dbus
    glib
    gtk3
    libgbm
    nss
    vivaldi-ffmpeg-codecs
  ];

  runtimeDependencies = [
    libglvnd
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "edhm-ui";
      exec = "edhm-ui";
      icon = "edhm-ui";
      desktopName = "EDHM UI";
      comment = "Elite Dangerous HUD Mod Manager";
      categories = [
        "Game"
        "Utility"
      ];
      startupWMClass = "edhm-ui-v3";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/edhm-ui

    install -Dm755 edhm-ui-v3 $out/opt/edhm-ui/edhm-ui-v3

    # Copy essential Electron runtime files
    cp chrome-sandbox chrome_crashpad_handler $out/opt/edhm-ui/
    cp *.pak *.bin *.dat snapshot_blob.bin v8_context_snapshot.bin $out/opt/edhm-ui/

    # Copy application resources
    cp -r resources $out/opt/edhm-ui/

    # Copy all locales (international support)
    cp -r locales $out/opt/edhm-ui/

    wrapProgram $out/opt/edhm-ui/edhm-ui-v3 \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libglvnd ]} # For libGL.so

    # Create symlink
    mkdir -p $out/bin
    ln -s $out/opt/edhm-ui/edhm-ui-v3 $out/bin/edhm-ui

    # Copy libraries needed for color previews. The versions from libglvnd don't work.
    cp libGLESv2.so $out/opt/edhm-ui/libGLESv2.so
    cp libEGL.so $out/opt/edhm-ui/libEGL.so

    # Install icon
    install -Dm644 $out/opt/edhm-ui/resources/images/icon.png $out/share/pixmaps/edhm-ui.png

    runHook postInstall
  '';

  meta = {
    description = "HUD modification manager for Elite Dangerous";
    homepage = "https://github.com/BlueMystical/EDHM_UI";
    license = [
      lib.licenses.gpl3Only
      {
        shortName = "edhm-custom";
        fullName = "EDHM Custom Restrictive License - Non-redistributable";
        free = false;
        redistributable = false;
      }
    ];
    maintainers = with lib.maintainers; [
      graysontinker
      michael-k-williams
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "edhm-ui";
    longDescription = ''
      EDHM UI is a GPL v3 licensed user interface for managing Elite Dangerous HUD modifications.
      It includes EDHM (Elite Dangerous HUD Mod) which has a custom restrictive license.

      Redistribution Permission: The copyright holder Fred89210 has granted explicit
      permission for EDHM to be redistributed as part of the EDHM-UI package in Nixpkgs
      (see REDISTRIBUTION_EXCEPTION.md in the EDHM repository).

      DLL Components: The package includes standard redistributable DLLs from official sources:
      - d3dcompiler_46.dll (Microsoft DirectX Runtime v9.30.9200.2078)
      - d3d11.dll (NVIDIA Corporation's Direct3D 11 implementation)
      - nvapi64.dll (NVIDIA API SDK library)
      These are unmodified redistributable components, not patched binaries.

      Note: The underlying EDHM tool normally has a custom license with significant restrictions:
      - Personal and non-commercial use only unless otherwise agreed
      - No modification, redistribution, or reuse without explicit permission
      - All rights reserved by original authors (Fred89210 and psychicEgg)

      This is a fan-made modification for Elite Dangerous and is not affiliated with
      Frontier Developments plc.
    '';
  };
})
