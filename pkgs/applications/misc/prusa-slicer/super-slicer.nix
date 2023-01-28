{ lib, fetchFromGitHub, fetchpatch, makeDesktopItem, prusa-slicer }:
let
  appname = "SuperSlicer";
  pname = "super-slicer";
  description = "PrusaSlicer fork with more features and faster development cycle";

  versions = {
    stable = {
      version = "2.3.57.12";
      sha256 = "sha256-lePhDRHI++9zs54bTt2/Lu6ZQ7egjJCWb752aI0s7Mw==";
      patches = null;
    };
    latest = {
      version = "2.4.58.3";
      sha256 = "sha256-pEZcBEvK4Mq8nytiXLJvta7Bk6qZRJfTNrYz7N/aUAE=";
      patches = [
        # Fix detection of TBB, see https://github.com/prusa3d/PrusaSlicer/issues/6355
        (fetchpatch {
          url = "https://github.com/prusa3d/PrusaSlicer/commit/76f4d6fa98bda633694b30a6e16d58665a634680.patch";
          sha256 = "1r806ycp704ckwzgrw1940hh1l6fpz0k1ww3p37jdk6mygv53nv6";
        })
        # Fix compile error with boost 1.79. See https://github.com/supermerill/SuperSlicer/issues/2823
        (fetchpatch {
          url = "https://raw.githubusercontent.com/gentoo/gentoo/81e3ca3b7c131e8345aede89e3bbcd700e1ad567/media-gfx/superslicer/files/superslicer-2.4.58.3-boost-1.79-port-v2.patch";
          # Excludes Linux-only patches
          excludes = [
            "src/slic3r/GUI/FreeCADDialog.cpp"
            "src/slic3r/GUI/Tab.cpp"
            "src/slic3r/Utils/Http.cpp"
          ];
          sha256 = "sha256-v0q2MhySayij7+qBTE5q01IOq/DyUcWnjpbzB/AV34c=";
        })
      ];
    };
  };

  override = { version, sha256, patches }: super: {
    inherit version pname patches;

    src = fetchFromGitHub {
      owner = "supermerill";
      repo = "SuperSlicer";
      inherit sha256;
      rev = version;
      fetchSubmodules = true;
    };

    # wxScintilla is not used on macOS
    prePatch = super.prePatch + ''
      substituteInPlace src/CMakeLists.txt \
        --replace "scintilla" ""
    '';

    # We don't need PS overrides anymore, and gcode-viewer is embedded in the binary.
    postInstall = null;
    separateDebugInfo = true;

    # See https://github.com/supermerill/SuperSlicer/issues/432
    cmakeFlags = super.cmakeFlags ++ [
      "-DSLIC3R_BUILD_TESTS=0"
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "superslicer";
        exec = "superslicer";
        icon = appname;
        comment = description;
        desktopName = appname;
        genericName = "3D printer tool";
        categories = [ "Development" ];
      })
    ];

    meta = with lib; {
      inherit description;
      homepage = "https://github.com/supermerill/SuperSlicer";
      license = licenses.agpl3;
      maintainers = with maintainers; [ cab404 moredread ];
      mainProgram = "superslicer";
    };

    passthru = allVersions;

  };
  allVersions = builtins.mapAttrs (_name: version: (prusa-slicer.overrideAttrs (override version))) versions;
in
allVersions.stable
