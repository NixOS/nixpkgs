# Elite Dangerous HUD Mod UI - GUI for managing HUD color modifications
# Note: Includes DLLs from the GPLv3-licensed 3Dmigoto project, and an unmodified redistributable Microsoft DirectX library
# - https://github.com/bo3b/3Dmigoto
# - See long description for more details
# Note: The underlying tool, EDHM, is restrictively licensed (see the 'edhm-custom' license)
# - Explicit redistribution permission granted by EDHM copyright holder for the purpose of inclusion in Nixpkgs only
# - https://github.com/psychicEgg/EDHM/blob/main/REDISTRIBUTION_EXCEPTION.md
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
  version = "3.0.63";

  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/BlueMystical/EDHM_UI/releases/download/v${finalAttrs.version}/edhm-ui-v3-linux-x64.zip";
    hash = "sha256-f+nVupCywLlZYLKB8O1tGJKOKq3zT8PQM5mjLcp2MOY=";
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
    install -Dm644 $out/opt/edhm-ui/resources/images/icon.png $out/share/icons/hicolor/256x256/apps/edhm-ui.png

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

      DLL Components: The package includes DLLs from the GPLv3-licensed 3Dmigoto project and an unmodified Microsoft DirectX library
      - d3dcompiler_46.dll (Microsoft DirectX Runtime v9.30.9200.20789, distributed as part of 3Dmigoto v1.3.16)
        - "You can redistribute this DLL to other computers with your application as a side-by-side DLL."
        - https://learn.microsoft.com/en-us/windows/win32/directx-sdk--august-2009-
      - d3d11.dll (from 3Dmigoto v1.3.16)
      - nvapi64.dll (from 3Dmigoto v1.3.16)
      The 3Dmigoto project can be found at https://github.com/bo3b/3Dmigoto

      Note: The underlying EDHM tool normally has a custom license with significant restrictions:
      - Personal and non-commercial use only unless otherwise agreed
      - No modification, redistribution, or reuse without explicit permission
      - All rights reserved by original authors (Fred89210 and psychicEgg)

      This is a fan-made modification for Elite Dangerous and is not affiliated with
      Frontier Developments plc.
    '';
  };
})
