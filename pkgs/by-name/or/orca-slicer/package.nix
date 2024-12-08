{
  lib,
  fetchFromGitHub,
  bambu-studio,
}:
bambu-studio.overrideAttrs (
  finalAttrs: previousAttrs: {
    version = "2.2.0";
    pname = "orca-slicer";

    src = fetchFromGitHub {
      owner = "SoftFever";
      repo = "OrcaSlicer";
      rev = "v${finalAttrs.version}";
      hash = "sha256-h+cHWhrp894KEbb3ic2N4fNTn13WlOSYoMsaof0RvRI=";
    };

    patches = [
      # Fix for webkitgtk linking
      ./patches/0001-not-for-upstream-CMakeLists-Link-against-webkit2gtk-.patch
      ./patches/dont-link-opencv-world-orca.patch
    ];

    preFixup = ''
      gappsWrapperArgs+=(
        # Fixes blackscreen dialogs
        --set WEBKIT_DISABLE_COMPOSITING_MODE 1
      )
    '';

    cmakeFlags = lib.remove "-DFLATPAK=1" previousAttrs.cmakeFlags or [ ];

    # needed to prevent collisions between the LICENSE.txt files of
    # bambu-studio and orca-slicer.
    postInstall = ''
      mv $out/LICENSE.txt $out/share/OrcaSlicer/LICENSE.txt
    '';

    meta = with lib; {
      description = "G-code generator for 3D printers (Bambu, Prusa, Voron, VzBot, RatRig, Creality, etc.)";
      homepage = "https://github.com/SoftFever/OrcaSlicer";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [
        zhaofengli
        ovlach
        pinpox
      ];
      mainProgram = "orca-slicer";
      platforms = platforms.linux;
    };
  }
)
