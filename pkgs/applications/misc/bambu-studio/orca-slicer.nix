{
  lib,
  fetchFromGitHub,
  bambu-studio,
}:
bambu-studio.overrideAttrs (
  finalAttrs: previousAttrs: {
    version = "2.1.1";
    pname = "orca-slicer";

    src = fetchFromGitHub {
      owner = "SoftFever";
      repo = "OrcaSlicer";
      rev = "v${finalAttrs.version}";
      hash = "sha256-7fusdSYpZb4sYl5L/+81PzMd42Nsejj+kCZsq0f7eIk=";
    };

    patches =[
      # FIXME: only required for 2.1.1, can be removed in the next version
      ./patches/0002-fix-build-for-gcc-13.diff
      # Fix for webkitgtk linking
      ./patches/0001-not-for-upstream-CMakeLists-Link-against-webkit2gtk-.patch
      # Fix build with cgal-5.6.1+
      ./patches/meshboolean-const.patch
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
