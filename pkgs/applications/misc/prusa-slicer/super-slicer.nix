{ lib, fetchFromGitHub, makeDesktopItem, prusa-slicer }:
let
  appname = "SuperSlicer";
  version = "2.3.56.5";
  pname = "super-slicer";
  description = "PrusaSlicer fork with more features and faster development cycle";
  override = super: {
    inherit version pname;

    src = fetchFromGitHub {
      owner = "supermerill";
      repo = "SuperSlicer";
      sha256 = "sha256-Gg+LT1YKyUGNJE9XvWE1LSlIQ6Vq5GfVBTUw/A7Qx7E=";
      rev = version;
      fetchSubmodules = true;
    };

    # We don't need PS overrides anymore, and gcode-viewer is embedded in the binary.
    postInstall = null;

    # See https://github.com/supermerill/SuperSlicer/issues/432
    cmakeFlags = super.cmakeFlags ++ [
      "-DSLIC3R_BUILD_TESTS=0"
    ];

    desktopItems = [
      (makeDesktopItem {
        name = appname;
        exec = "superslicer";
        icon = appname;
        comment = description;
        desktopName = appname;
        genericName = "3D printer tool";
        categories = "Development;";
      })
    ];

    meta = with lib; {
      inherit description;
      homepage = "https://github.com/supermerili/SuperSlicer";
      license = licenses.agpl3;
      maintainers = with maintainers; [ cab404 moredread ];
    };

  };
in prusa-slicer.overrideAttrs override
