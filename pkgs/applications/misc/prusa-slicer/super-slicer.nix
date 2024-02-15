{ lib, fetchFromGitHub, fetchpatch, makeDesktopItem, wxGTK31, prusa-slicer, libspnav }:
let
  appname = "SuperSlicer";
  pname = "super-slicer";
  description = "PrusaSlicer fork with more features and faster development cycle";

  patches = [
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

  versions = {
    stable = {
      version = "2.3.57.12";
      sha256 = "sha256-lePhDRHI++9zs54bTt2/Lu6ZQ7egjJCWb752aI0s7Mw==";
      patches = null;
    };
    latest = {
      version = "2.4.58.5";
      sha256 = "sha256-UywxEGedXaBUTKojEkbkuejI6SdPSkPxTJMwUDNW6W0=";
      inherit patches;
    };
    beta = {
      version = "2.5.59.6";
      sha256 = "sha256-4ivhkcvVw5NlPsDz3J840aWc0qnp/XzCnTTCICwi3/c=";
      inherit patches;
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

    # - wxScintilla is not used on macOS
    # - Partially applied upstream changes cause a bug when trying to link against a nonexistent libexpat
    prePatch = super.prePatch + ''
      substituteInPlace src/CMakeLists.txt \
        --replace "scintilla" "" \
        --replace "list(APPEND wxWidgets_LIBRARIES libexpat)" "list(APPEND wxWidgets_LIBRARIES EXPAT::EXPAT)"

      substituteInPlace src/libslic3r/CMakeLists.txt \
        --replace "libexpat" "EXPAT::EXPAT"
    '';

    # We don't need PS overrides anymore, and gcode-viewer is embedded in the binary.
    postInstall = null;
    separateDebugInfo = true;

    buildInputs = super.buildInputs ++ [
      libspnav
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
      maintainers = with maintainers; [ cab404 moredread tmarkus ];
      mainProgram = "superslicer";
    };

    passthru = allVersions;

  };
 wxGTK31-prusa = wxGTK31.overrideAttrs (old: rec {
    pname = "wxwidgets-prusa3d-patched";
    version = "3.1.4";
    src = fetchFromGitHub {
      owner = "prusa3d";
      repo = "wxWidgets";
      rev = "489f6118256853cf5b299d595868641938566cdb";
      hash = "sha256-xGL5I2+bPjmZGSTYe1L7VAmvLHbwd934o/cxg9baEvQ=";
      fetchSubmodules = true;
    };
  });
  prusa-slicer-wxGTK-override = prusa-slicer.override { wxGTK-override = wxGTK31-prusa; };
  allVersions = builtins.mapAttrs (_name: version: (prusa-slicer-wxGTK-override.overrideAttrs (override version))) versions;
in
allVersions.stable
