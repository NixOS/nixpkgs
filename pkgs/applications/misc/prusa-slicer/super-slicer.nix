{
  lib,
  fetchFromGitHub,
  fetchpatch,
  makeDesktopItem,
  wxGTK31,
  prusa-slicer,
  libspnav,
  opencascade-occt_7_6,
}:
let
  appname = "SuperSlicer";
  pname = "super-slicer";
  description = "PrusaSlicer fork with more features and faster development cycle";

  patches = [
    # Drop if this fix gets merged upstream
    (fetchpatch {
      url = "https://github.com/supermerill/SuperSlicer/commit/fa7c545efa5d1880cf24af32083094fc872d3692.patch";
      hash = "sha256-fh31qrqjQiRQL03pQl4KJAEtbKMwG8/nJroqIDOIePw=";
    })
    ./super-slicer-use-boost186.patch
  ];

  versions = {
    stable = {
      version = "2.5.59.13";
      hash = "sha256-FkoGcgVoBeHSZC3W5y30TBPmPrWnZSlO66TgwskgqAU=";
      inherit patches;
    };
    latest = {
      version = "2.5.59.13";
      hash = "sha256-FkoGcgVoBeHSZC3W5y30TBPmPrWnZSlO66TgwskgqAU=";
      inherit patches;
    };
    beta = {
      version = "2.5.60.0";
      hash = "sha256-dDRK07SatLLhuoc2fJKbHUwAofRRvBUoXWO61W2blFM=";
      inherit patches;
    };
  };

  override =
    {
      version,
      hash,
      patches,
    }:
    super: {
      inherit version pname patches;

      src = fetchFromGitHub {
        owner = "supermerill";
        repo = "SuperSlicer";
        inherit hash;
        rev = version;
        fetchSubmodules = true;
      };

      # - wxScintilla is not used on macOS
      # - Partially applied upstream changes cause a bug when trying to link against a nonexistent libexpat
      postPatch =
        (super.postPatch or "")
        + ''
          substituteInPlace src/CMakeLists.txt \
            --replace "scintilla" "" \
            --replace "list(APPEND wxWidgets_LIBRARIES libexpat)" "list(APPEND wxWidgets_LIBRARIES EXPAT::EXPAT)"

          substituteInPlace src/libslic3r/CMakeLists.txt \
            --replace "libexpat" "EXPAT::EXPAT"

          # fixes GCC 14 error
          substituteInPlace src/libslic3r/MeshBoolean.cpp \
            --replace-fail 'auto &face' 'auto face' \
            --replace-fail 'auto &vi' 'auto vi'
        '';

      # We don't need PS overrides anymore, and gcode-viewer is embedded in the binary
      # but we do still need to move OCCTWrapper.so to the lib directory
      postInstall = ''
        if [[ -f $out/bin/OCCTWrapper.so ]]; then
          mkdir -p "$out/lib"
          mv -v $out/bin/*.* $out/lib/
        fi
      '';
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
        license = licenses.agpl3Plus;
        maintainers = with maintainers; [
          cab404
          tmarkus
        ];
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
  prusa-slicer-deps-override = prusa-slicer.override {
    wxGTK-override = wxGTK31-prusa;
    opencascade-override = opencascade-occt_7_6;
  };
  allVersions = builtins.mapAttrs (
    _name: version: (prusa-slicer-deps-override.overrideAttrs (override version))
  ) versions;
in
allVersions.stable
