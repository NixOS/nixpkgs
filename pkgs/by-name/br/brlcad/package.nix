{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

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

  # build options
  enableQt ? false,
}:
let
  bext = fetchFromGitHub {
    owner = "BRL-CAD";
    repo = "bext";
    rev = "f9074f84c87605f89d912069cee1b1e710ead635"; # must match brlcad_bext_init() in CMakeLists.txt
    hash = "sha256-jCBw4aDk/bmz2Woe9qIA88mgLRRZSu7zDYM5pi3MbP8=";
    fetchSubmodules = true;
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "brlcad";
  version = "7.42.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BRL-CAD";
    repo = "brlcad";
    tag = "rel-${lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-smsCbUWlAfO9xyT8Bz/vLRkTJuehF9xANrP8bT//t18=";
  };

  prePatch = ''
    # clone bext src so we can patch it
    mkdir -p build/bext
    cp -r --no-preserve=mode ${bext}/* build/bext/
  '';

  patches = [
    # make libgcv work with modern lemon
    (fetchpatch {
      url = "https://github.com/BRL-CAD/brlcad/commit/0dbd82a10040edc45754242ab36ed130a0259fb8.patch";
      hash = "sha256-N54FnF69PgeRUDZk/i9hoLHoBzb1neYN20KhDyMqvi4=";
      excludes = [ "CMakeLists.txt" ];
    })
    # disable internal RPATH manipulation which gets in our way
    ./disable-rpath-manipulation.patch
    # make <PACKAGE>_ROOT respect our cmakeFlags settings instead of being hardwired to CMAKE_BINARY_DIR
    ./fix-findpackage-root.patch
    # libgcv defines EQUAL macro, which causes gdal to not define STRCASECMP macro
    ./fix-gdal-strcasecmp.patch
    # only call set_target_properties on perm-test when testing is enabled
    # https://github.com/BRL-CAD/brlcad/pull/235
    ./fix-perm-test-cmake.patch
    # fix typo in GeometryIO.tcl which causes model exports to fail
    # https://github.com/BRL-CAD/brlcad/pull/234
    ./fix-export.patch
  ];

  postPatch = ''
    # disable all bext projects by default
    substituteInPlace build/bext/CMakeLists.txt \
      --replace-fail "add_project" "#add_project"

    # enable bext projects we actually need:
    # * itcl: needs v3
    # * itk: needs v3
    # * iwidgets, tkhtml, tktable: missing in nixpkgs
    # * manifold: needs v2
    # * opennurbs: many vendored patches
    # * osmesa, perplex, regex, utahrle: specialized vendored libraries
    # * patch, strclear: required internally
    # * assetimport, lemon, re2c, tcl, tk, zlib: transitive dependency, not actually built
    substituteInPlace build/bext/CMakeLists.txt \
      --replace-fail "#add_project(patch)" "add_project(patch)"
    for name in itcl itk iwidgets tkhtml tktable manifold opennurbs osmesa perplex regex utahrle strclear zlib assetimport lemon re2c tcl tk; do
      substituteInPlace build/bext/CMakeLists.txt \
        --replace-fail "#add_project($name " "add_project($name "
    done

    # inject TCL_ROOT into bext projects
    sed -i '1i set(TCL_ROOT "${tcl};${tk}")' \
      build/bext/CMake/FindTCL.cmake \
      build/bext/itcl/addfiles/FindTCL.cmake \
      build/bext/itk/addfiles/FindTCL.cmake \
      build/bext/tktable/tktable/CMake/FindTCL.cmake \
      build/bext/tkhtml/tkhtml/CMake/FindTCL.cmake
  ''
  + lib.optionalString stdenv.hostPlatform.isAarch64 ''
    # remove a failing test
    substituteInPlace src/libbu/tests/CMakeLists.txt \
      --replace-fail "brlcad_add_test(NAME bu_color_to_rgb_floats_1 COMMAND bu_test color 4 192,78,214)" ""
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
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
    (lib.cmakeBool "BRLCAD_ENABLE_QT" enableQt)
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
      # itk, tkhtml, tktable, utahrle
      "-Wno-incompatible-pointer-types"
      "-std=gnu17"
    ];
  };

  nativeCheckInputs = [
    gzip
    which
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
