{ lib, fetchFromGitHub, makeDesktopItem, prusa-slicer }:
let
  appname = "SuperSlicer";
  pname = "super-slicer";
  description = "PrusaSlicer fork with more features and faster development cycle";

  versions = {
    stable = { version = "2.3.56.9"; sha256 = "sha256-vv01wGQkrasKKjpGSDeDqZbd1X5/iTfGXYN5Jwz+FKE="; };
    staging = { version = "2.3.57.0"; sha256 = "sha256-7o0AqgQcKYc6c+Hi3x5pC/pKJZPlEsYOYk9sC21+mvM="; };
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
    };

    passthru = allVersions;

  };

  allVersions = builtins.mapAttrs (_name: version: (prusa-slicer.overrideAttrs (override version))) versions;
in
allVersions.stable
