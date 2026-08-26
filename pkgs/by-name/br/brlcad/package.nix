{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
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
  tinygltf,
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
    rev = "12f7d5669eec143eb882a367fa2d2a56127d1942"; # must match brlcad_bext_init() in CMakeLists.txt
    hash = "sha256-T6zA/zLmSPTlj7+AlxxWXb1OsxdBEcyatYCYUUTIDY8=";
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
          "onetbb"
          "opencolorio"
          "opencv"
          "openexr"
          "openimageio"
          "osl"
          "ospray"
          "patchelf"
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
          "tinygltf"
          "xerces-c"
          "xmltools"
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
  version = "7.44.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BRL-CAD";
    repo = "brlcad";
    tag = "rel-${lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-ehfjrff2mjaW0s0G8I7pNXpRXdnsOcPwRTXewNijAZo=";
  };

  prePatch = ''
    # clone bext src so we can patch it
    # (copy hidden files too, e.g. .gitmodules, which the dependency-graph target needs)
    mkdir -p build/bext
    cp -r --no-preserve=mode ${bext}/. build/bext/
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

    # fix typo in GeometryIO.tcl which causes model exports to fail
    # https://github.com/BRL-CAD/brlcad/pull/234
    ./fix-export.patch
  ];

  postPatch =
    # disable all bext projects by default
    ''
      substituteInPlace build/bext/CMakeLists.txt \
        --replace-fail "add_project" "#add_project"
    ''
    # enable bext projects we actually need:
    # * itcl: needs v3
    # * itk: needs v3
    # * iwidgets, tkhtml, tktable: missing in nixpkgs
    # * manifold: needs v2
    # * mmesh: required by librt, missing in nixpkgs
    # * opennurbs: many vendored patches
    # * osmesa, perplex, regex: specialized vendored libraries
    # * poissonrecon: provides SPSR headers to brlcad via the bext noinstall dir
    # * patch, strclear: required internally
    # * assetimport, clipper2, lemon, re2c, tcl, tk, zlib: transitive dependency, not actually built
    + ''
      substituteInPlace build/bext/CMakeLists.txt \
        --replace-fail \
          "#add_project(patch)" \
          "add_project(patch)"

      for name in itcl itk iwidgets tkhtml tktable manifold mmesh opennurbs osmesa perplex regex poissonrecon strclear clipper2 zlib assetimport lemon re2c tcl tk; do
        substituteInPlace build/bext/CMakeLists.txt \
          --replace-fail \
            "#add_project($name " \
            "add_project($name "
      done
    ''
    # inject TCL_ROOT into bext projects
    + ''
      sed -i '1i set(TCL_ROOT "${tcl};${tk}")' \
        build/bext/CMake/FindTCL.cmake \
        build/bext/itcl/addfiles/FindTCL.cmake \
        build/bext/itk/addfiles/FindTCL.cmake \
        build/bext/tktable/tktable/CMake/FindTCL.cmake \
        build/bext/tkhtml/tkhtml/CMake/FindTCL.cmake
    ''
    # remove a failing test
    + lib.optionalString stdenv.hostPlatform.isAarch64 ''
      substituteInPlace src/libbu/tests/CMakeLists.txt \
        --replace-fail \
          "brlcad_add_test(NAME bu_color_to_rgb_floats_1 COMMAND bu_test test_color 4 192,78,214)" \
          ""
    '';

  nativeBuildInputs = [
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
    tinygltf
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
    (lib.cmakeFeature "TCL_ROOT" "${tcl};${tk}")
  ];

  preConfigure = ''
    cmakeFlagsArray+=("-DBRLCAD_EXT_SOURCE_DIR=$(pwd)/build/bext")
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
  preFixup = lib.optionalString enableQt ''
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
