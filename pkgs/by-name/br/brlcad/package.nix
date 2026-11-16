{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  autoPatchelfHook,
  cmake,
  doxygen,
  lemon,
  libxslt,
  re2c,

  # buildInputs
  adaptagrams,
  assimp,
  clipper2,
  eigen,
  gdal,
  geogram,
  gtmathematics,
  libGL,
  libjpeg_turbo,
  libpng,
  lmdb,
  netpbm,
  opencv,
  openmesh,
  pugixml,
  qt6,
  stepcode,
  tcl,
  tk,
  zlib,

  # nativeCheckInputs
  gzip,
  which,
  writableTmpDirAsHomeHook,

  # build options
  enableQt ? false,
}:
let
  bext = fetchFromGitHub {
    owner = "BRL-CAD";
    repo = "bext";
    rev = "42d8d7ca57f9d2f61192b41f0b41a731f1ba6c47"; # must match brlcad_bext_init() in CMakeLists.txt
    hash = "sha256-LHMZwu35L2dpWh7mq0RkMjTdgu5AE2VXmfAAGTjPUAY=";
    fetchSubmodules = true;
    # remove unneeded subprojects to reduce NAR size
    postFetch =
      let
        subprojectsToRemove = toString [
          "appleseed"
          "astyle"
          "boost"
          "bullet"
          "deflate"
          "eigen"
          "embree"
          "expat"
          "flexbison"
          "fmt"
          "gdal"
          "gte"
          "icu"
          "ispc"
          "jpeg"
          "lief"
          "llvm"
          "lmdb"
          "lz4"
          "minizip-ng"
          "ncurses"
          "netpbm"
          "oidn"
          "onetbb"
          "opencolorio"
          "opencv"
          "openexr"
          "openimageio"
          "openvdb"
          "osl"
          "ospray"
          "plief"
          "png"
          "proj"
          "pugixml"
          "pystring"
          "qt"
          "rkcommon"
          "sqlite3"
          "stepcode"
          "tiff"
          "xerces-c"
          "yaml-cpp"
          "zstd"
        ];
      in
      ''
        for name in ${subprojectsToRemove}; do
          rm -r $out/$name
        done
      '';
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "brlcad";
  version = "7.46.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BRL-CAD";
    repo = "brlcad";
    tag = "rel-${lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-ZiqL7tN4Wpjt3NY+nNOPh3MlxvrrOoZ9123lLCwi3z8=";
  };

  prePatch = ''
    # clone bext src so we can patch it
    # (copy hidden files too, e.g. .gitmodules, which the dependency-graph target needs)
    # (keep the executable bits, the bundled Tcl/Tk configure scripts need them)
    mkdir -p build/bext
    cp -r ${bext}/. build/bext/
    chmod -R u+w build/bext
  '';

  patches = [
    # disable internal RPATH manipulation which gets in our way
    ./disable-rpath-manipulation.patch

    # make <PACKAGE>_ROOT respect our cmakeFlags settings instead of being hardwired to CMAKE_BINARY_DIR
    ./fix-findpackage-root.patch

    # only reset a dependency's cached find_package results when the third-party
    # state actually changed, so externally-injected values (e.g. GTE_INCLUDE_DIR)
    # survive configure instead of being unconditionally cleared
    ./restore-find-package-reset-guard.patch

    # libgcv defines EQUAL macro, which causes gdal to not define STRCASECMP macro
    ./fix-gdal-strcasecmp.patch
  ];

  postPatch =
    # disable all bext projects by default
    ''
      substituteInPlace build/bext/CMakeLists.txt \
        --replace-fail "add_project" "#add_project"
    ''
    # enable bext projects we actually need:
    # * tcl, tk, itk: bext requires Itcl >= 4.3.0 / Itk >= 4.2.3 from the same Tcl
    #   installation (nixpkgs has incrtcl 4.2.3, itktcl 4.1.0), so use the bundled stack
    # * iwidgets, tkhtml, tktable: missing in nixpkgs
    # * manifold: needs v2
    # * mmesh: required by librt, missing in nixpkgs
    # * opennurbs: many vendored patches
    # * osmesa, perplex, regex: specialized vendored libraries
    # * poissonrecon: provides SPSR headers to brlcad via the bext noinstall dir
    # * tinygltf: brlcad needs the `tinygltf::tinygltf` CMake target that bext patches
    #   into its tinygltf v3 snapshot (nixpkgs' tinygltf 3.x only ships headers)
    # * patch, strclear: required internally
    # * assetimport, clipper2, lemon, re2c, zlib: transitive dependency, not actually built
    + ''
      substituteInPlace build/bext/CMakeLists.txt \
        --replace-fail \
          "#add_project(patch)" \
          "add_project(patch)"

      for name in itk iwidgets tkhtml tktable manifold mmesh opennurbs osmesa perplex regex poissonrecon strclear tinygltf clipper2 zlib assetimport lemon re2c tcl tk; do
        substituteInPlace build/bext/CMakeLists.txt \
          --replace-fail \
            "#add_project($name " \
            "add_project($name "
      done
    ''
    # bext's finalize step falls back to stdenv's patchelf to overwrite the RPATH
    # of every installed library, dropping the nix store paths (e.g. to zlib)
    + ''
      substituteInPlace build/bext/CMakeLists.txt \
        --replace-fail \
          "NAMES plief patchelf" \
          "NAMES plief"
    ''
    # inject TCL_ROOT into bext projects
    + ''
      sed -i '1i set(TCL_ROOT "${tcl};${tk}")' \
        build/bext/CMake/FindTCL.cmake
    ''
    # remove failing tests
    + lib.optionalString stdenv.hostPlatform.isAarch64 ''
      substituteInPlace src/libbu/tests/CMakeLists.txt \
        --replace-fail \
          "brlcad_add_test(NAME bu_color_to_rgb_floats_1 COMMAND bu_test test_color 4 192,78,214)" \
          ""
    ''
    # This test opens 16k mapped files from every CPU, each open being a linear scan
    # under one global semaphore, so its runtime explodes on many-core machines and
    # blows past ctest's 1500s default timeout on our 80-core aarch64 builders.
    + lib.optionalString stdenv.hostPlatform.isAarch64 ''
      substituteInPlace src/libbu/tests/CMakeLists.txt \
        --replace-fail \
          "brlcad_add_test(NAME bu_mappedfile_parallel_16384 COMMAND bu_test test_mappedfile 2 16384)" \
          ""
    ''
    # Floating-point differences on aarch64:
    # - bg_spsr: "fixed structured reconstruction succeeds" fails
    # - ged_test_drawing_annotate: rendering differs from the x86_64 reference image (SSIM 0.94)
    + lib.optionalString stdenv.hostPlatform.isAarch64 ''
      substituteInPlace src/libbg/tests/CMakeLists.txt \
        --replace-fail \
          "brlcad_add_test(NAME bg_spsr COMMAND bg_spsr)" \
          ""
      sed -i '/^brlcad_add_test($/{N;/NAME ged_test_drawing_annotate/{N;N;d}}' \
        src/libged/tests/draw/CMakeLists.txt
      ! grep -q "NAME ged_test_drawing_annotate" src/libged/tests/draw/CMakeLists.txt
    '';

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    doxygen
    lemon
    libxslt
    re2c
  ]
  ++ lib.optionals enableQt [
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    adaptagrams
    assimp
    clipper2
    eigen
    gdal
    geogram
    gtmathematics
    libGL
    libjpeg_turbo
    libpng
    lmdb
    netpbm
    opencv
    openmesh
    pugixml
    stepcode
    tcl
    tk
    zlib
  ]
  ++ lib.optionals enableQt [
    qt6.qtbase
    qt6.qtsvg
  ];

  cmakeFlags = [
    (lib.cmakeBool "BRLCAD_ENABLE_STRICT" false)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BRLCAD_ENABLE_QT" enableQt)
    # static-library link-closure validation tests fail to link (libbn's static
    # target does not pull in its libbu dependency); we only ship the shared libs
    (lib.cmakeBool "BRLCAD_VALIDATE_STATIC_LINKS" false)
    (lib.cmakeFeature "GTE_INCLUDE_DIR" "${gtmathematics}/include/gtmathematics")
    (lib.cmakeFeature "LMDB_LIBRARY" "${lmdb.out}/lib/liblmdb${stdenv.hostPlatform.extensions.sharedLibrary}")
    (lib.cmakeFeature "LMDB_INCLUDE_DIR" "${lmdb.dev}/include")
    (lib.cmakeFeature "OpenCV_DIR" "${opencv}/lib/cmake/opencv4")
    (lib.cmakeFeature "STEPCODE_ROOT" "${stepcode}")
    # No TCL_ROOT here: brlcad must link the bundled Tcl/Tk stack that bext builds,
    # since its btclsh loads that stack's init.tcl.
  ];

  preConfigure = ''
    cmakeFlagsArray+=("-DBRLCAD_EXT_SOURCE_DIR=$(pwd)/build/bext")
  '';

  # bext installs its libraries with an empty RUNPATH (e.g. libOpenNURBS -> libz, libtk -> libX11).
  # Fix the copies staged in the build tree before brlcad links against them.
  # The path must be absolute, or libraries found there (e.g. libmanifold -> libClipper2)
  # get a relative `lib` RUNPATH.
  postConfigure = ''
    autoPatchelf "$PWD/lib"
  '';

  env = {
    CXXFLAGS = toString [
      # src/libbg/spsr/Octree.inl
      "-Wno-template-body"
      # manifold: clipper.core.h:181:22: error: template-id not allowed for constructor in C++20
      "-Wno-error=template-id-cdtor"
    ];
    CFLAGS = toString [
      # itk, tkhtml, tktable
      "-Wno-incompatible-pointer-types"
      "-std=gnu17"
    ];
  };

  nativeCheckInputs = [
    gzip
    which
    # bu_dir test writes into HOME/cache/config, which must be writable
    writableTmpDirAsHomeHook
  ];

  doCheck = true;

  # Only wrap Qt apps as other executables stop working when wrapped
  dontWrapQtApps = true;
  preFixup =
    # The bext libraries patched in postConfigure are installed with the build-tree RUNPATH.
    # Drop it; autoPatchelfHook resolves their dependencies from $out/lib afterwards.
    ''
      for f in $(find $out -type f); do
        isELF "$f" || continue
        rpath=$(patchelf --print-rpath "$f" 2>/dev/null) || continue
        newRpath=$(tr ':' '\n' <<< "$rpath" | grep -v '^/build/' | paste -sd: -)
        if [ "$rpath" != "$newRpath" ]; then
          patchelf --set-rpath "$newRpath" "$f"
        fi
      done
    ''
    + lib.optionalString enableQt ''
      wrapQtApp $out/bin/brlman
      wrapQtApp $out/bin/qged
      wrapQtApp $out/bin/qgmodel
      wrapQtApp $out/bin/qgview
      wrapQtApp $out/bin/qisst
    '';

  meta = {
    homepage = "https://brlcad.org";
    description = "BRL-CAD is a powerful cross-platform open source combinatorial solid modeling system";
    changelog = "https://github.com/BRL-CAD/brlcad/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      lgpl21
      bsd2
    ];
    maintainers = with lib.maintainers; [
      GaetanLepage
      wishstudio
    ];
    platforms = lib.platforms.all;
  };
})
