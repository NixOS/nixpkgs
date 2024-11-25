{
  lib,
  fetchFromGitHub,
  bambu-studio,
  webkitgtk_4_0,
  webkitgtk_4_1,
  pkg-config,
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

    nativeBuildInputs = (previousAttrs.nativeBuildInputs or [ ]) ++ [
      pkg-config
    ];

    buildInputs = (lib.remove webkitgtk_4_0 previousAttrs.buildInputs or [ ]) ++ [
      webkitgtk_4_1
    ];

    cmakeFlags = (previousAttrs.cmakeFlags or [ ]) ++ [
      "-DUSE_WEBKIT_4_1=ON"
    ];

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
