{ lib, fetchFromGitHub, makeDesktopItem, prusa-slicer }:
let
  appname = "SuperSlicer";
  pname = "super-slicer";
  description = "PrusaSlicer fork with more features and faster development cycle";

  versions = {
    stable = { version = "2.3.57.10"; sha256 = "sha256-/1oZgmZpRoizVpklKaI12qP4bVIGYyVpybmuCIz3Y0M="; };
    latest = { version = "2.3.57.10"; sha256 = "sha256-/1oZgmZpRoizVpklKaI12qP4bVIGYyVpybmuCIz3Y0M="; };
  };

  override = { version, sha256 }: super: {
    inherit version pname;

    src = fetchFromGitHub {
      owner = "supermerill";
      repo = "SuperSlicer";
      inherit sha256;
      rev = version;
      fetchSubmodules = true;
    };

    patches = null;

    # We don't need PS overrides anymore, and gcode-viewer is embedded in the binary.
    postInstall = null;
    separateDebugInfo = true;

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
      mainProgram = "superslicer";
    };

    passthru = allVersions;

  };

  allVersions = builtins.mapAttrs (_name: version: (prusa-slicer.overrideAttrs (override version))) versions;
in
allVersions.stable
