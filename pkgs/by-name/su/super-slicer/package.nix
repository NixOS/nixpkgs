{
  clangStdenv,
  lib,
  binutils,
  fetchFromGitHub,
  fetchpatch,
  makeDesktopItem,
  wxwidgets-prusa3d,
  libspnav,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  boost186,
  cereal,
  cgal_5,
  curl,
  dbus,
  eigen,
  expat,
  glew,
  glib,
  glib-networking,
  gmp,
  gtk3,
  hicolor-icon-theme,
  hidapi,
  libpng,
  mpfr,
  nanosvg-fltk,
  nlopt,
  nlohmann_json,
  opencascade-occt_7_6,
  openvdb,
  qhull,
  onetbb,
  wxwidgets_3_2,
  libx11,
  libbgcode,
  heatshrink,
  catch2_3,
  webkitgtk_4_1,
  ctestCheckHook,
  withSystemd ? lib.meta.availableOn clangStdenv.hostPlatform systemdLibs,
  systemdLibs,
  udevCheckHook,
  z3,
}:
let
  versionDataSets =
    let
      stable = {
        version = "2.5.59.13";
        srcHash = "sha256-FkoGcgVoBeHSZC3W5y30TBPmPrWnZSlO66TgwskgqAU=";
        patches = [
          # Drop if this fix gets merged upstream
          (fetchpatch {
            url = "https://github.com/supermerill/SuperSlicer/commit/fa7c545efa5d1880cf24af32083094fc872d3692.patch";
            hash = "sha256-fh31qrqjQiRQL03pQl4KJAEtbKMwG8/nJroqIDOIePw=";
          })
          ./super-slicer-use-boost186.patch
          ./super-slicer-fix-cereal-1.3.1.patch
          # Pick https://github.com/prusa3d/PrusaSlicer/pull/14207 to remove unused and insecure ilmbase dependency
          ./no-ilmbase.patch
        ];
        wxwidgets = wxwidgets-prusa3d;
      };
    in
    {
      inherit stable;
      latest = stable;
      beta = {
        version = "2.7.61.6";
        srcHash = "sha256-j9er2/z4jl04HI6aOMJ6YCXwhZ6qEhgMJjW117cLnz0=";
        patches = [ ./super-slicer-allow-wayland.patch ];
        wxwidgets = wxwidgets_3_2;
      };
    };

  mkPackage =
    versionDataSet:
    clangStdenv.mkDerivation (finalAttrs: {
      pname = "super-slicer";
      inherit (versionDataSet) version;

      # Build with clang even on Linux, because GCC uses absolutely obscene amounts of memory
      # on this particular code base (OOM with 32GB memory and --cores 16 on GCC, succeeds
      # with --cores 32 on clang).
      src = fetchFromGitHub {
        owner = "supermerill";
        repo = "SuperSlicer";
        hash = versionDataSet.srcHash;
        rev = finalAttrs.version;
        fetchSubmodules = true;
      };

      inherit (versionDataSet) patches;

      postPatch = ''
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

      nativeBuildInputs = [
        cmake
        pkg-config
        wrapGAppsHook3
        (versionDataSet.wxwidgets)
        udevCheckHook
      ];

      buildInputs = [
        binutils
        boost186 # does not build with 1.87, see https://github.com/prusa3d/PrusaSlicer/issues/13799
        cereal
        cgal_5
        curl
        dbus
        eigen
        expat
        glew
        glib
        glib-networking
        gmp
        gtk3
        hicolor-icon-theme
        hidapi
        libpng
        mpfr
        nanosvg-fltk
        nlopt
        opencascade-occt_7_6
        openvdb
        qhull
        onetbb
        (versionDataSet.wxwidgets)
        libx11
        libbgcode
        heatshrink
        catch2_3
        webkitgtk_4_1
        z3
        nlohmann_json
        libspnav
      ]
      ++ lib.optional withSystemd systemdLibs;

      strictDeps = true;

      separateDebugInfo = true;

      doInstallCheck = true;

      env = {
        # The build system uses custom logic - defined in
        # cmake/modules/FindNLopt.cmake in the package source - for finding the nlopt
        # library, which doesn't pick up the package in the nix store.  We
        # additionally need to set the path via the NLOPT environment variable.
        NLOPT = nlopt;
      }
      // lib.optionalAttrs withSystemd {
        # prusa-slicer uses dlopen on `libudev.so` at runtime
        NIX_LDFLAGS = "-ludev";
      };

      prePatch = ''
        # Since version 2.5.0 of nlopt we need to link to libnlopt, as libnlopt_cxx
        # now seems to be integrated into the main lib.
        sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake

        # Disable slic3r_jobs_tests.cpp as the test fails sometimes
        sed -i 's|slic3r_jobs_tests.cpp||g' tests/slic3rutils/CMakeLists.txt

        # prusa-slicer expects the OCCTWrapper shared library in the same folder as
        # the executable when loading STEP files. We force the loader to find it in
        # the usual locations (i.e. LD_LIBRARY_PATH) instead. See the manpage
        # dlopen(3) for context.
        if [ -f "src/libslic3r/Format/STEP.cpp" ]; then
          substituteInPlace src/libslic3r/Format/STEP.cpp \
            --replace-fail 'libpath /= "OCCTWrapper.so";' 'libpath = "OCCTWrapper.so";'
        fi
        # https://github.com/prusa3d/PrusaSlicer/issues/9581
        if [ -f "cmake/modules/FindEXPAT.cmake" ]; then
          rm cmake/modules/FindEXPAT.cmake
        fi

        # Fix resources folder location on macOS
        substituteInPlace src/PrusaSlicer.cpp \
          --replace-fail "#ifdef __APPLE__" "#if 0"
      '';

      cmakeFlags = [
        "-DSLIC3R_STATIC=0"
        "-DSLIC3R_FHS=1"
        "-DSLIC3R_GTK=3"
        "-DCMAKE_CXX_FLAGS=-DBOOST_LOG_DYN_LINK"
        # there is many different min versions set across different
        # Find*.cmake files, substituting them all is not viable
        "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
      ];

      postInstall = ''
        if [[ -f $out/bin/OCCTWrapper.so ]]; then
          mkdir -p "$out/lib"
          mv -v $out/bin/*.* $out/lib/
        fi
      '';

      preFixup = ''
        gappsWrapperArgs+=(
          --prefix LD_LIBRARY_PATH : "$out/lib"
        )
      '';

      desktopItems = [
        (makeDesktopItem {
          name = "superslicer";
          exec = "superslicer";
          icon = "SuperSlicer";
          comment = finalAttrs.meta.description;
          desktopName = "SuperSlicer";
          genericName = "3D printer tool";
          categories = [ "Development" ];
        })
      ];

      doCheck = true;
      nativeCheckInputs = [ ctestCheckHook ];
      checkFlags = [
        "--force-new-ctest-process"
        "-E"
        "libslic3r_tests|sla_print_tests"
      ];

      passthru = allVersions;

      meta = {
        description = "PrusaSlicer fork with more features and faster development cycle";
        homepage = "https://github.com/supermerill/SuperSlicer";
        license = lib.licenses.agpl3Plus;
        maintainers = with lib.maintainers; [
          cab404
          tmarkus
        ];
        mainProgram = "superslicer";
      };
    });

  allVersions = lib.mapAttrs (_: mkPackage) versionDataSets;
in
allVersions.stable
