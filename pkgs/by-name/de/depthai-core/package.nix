{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  apriltag,
  argparse,
  backward-cpp,
  boost,
  bzip2,
  catch2_3,
  clang-tools,
  depthai-data,
  eigen,
  fmt,
  fp16,
  gcc-unwrapped,
  git,
  httplib,
  jsoncpp,
  libarchive,
  libcpr,
  libnop,
  libusb1,
  lz4,
  magic-enum,
  neargye-semver,
  nlohmann_json,
  opencv4,
  openssl,
  pcl,
  protobuf_21,
  python3Packages,
  spdlog,
  trompeloeil,
  websocketpp,
  yaml-cpp,
  xlink,
  xtensor,
  xz,
  zlib,
  buildExamples ? false,
  buildPython ? true,
  buildTests ? false,
  basaltSupport ? false,
  opencvSupport ? true,
  pclSupport ? true,
  rtabmapSupport ? false,
  xtensorSupport ? true,
}:

let
  catch2_3WithSharedLibs = catch2_3.overrideAttrs (oldAttrs: {
    cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
      (lib.cmakeBool "BUILD_SHARED_LIBS" (!(stdenv.hostPlatform.isStatic)))
    ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "depthai-core";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "luxonis";
    repo = "depthai-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xThLfY+XsC96v5/k5exzpI4K1u4bXbZ55OD1pexMK0U=";
    fetchSubmodules = true;
  };

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    ./0001-gcc15.patch
    ./0002-cmake-fixes.patch
    ./0003-httplib-fixes.patch
  ];

  nativeBuildInputs = [
    cmake
    clang-tools
    git
    pkg-config
  ];

  buildInputs = [
    apriltag
    argparse
    backward-cpp
    bzip2
    boost
    catch2_3WithSharedLibs
    depthai-data
    eigen
    fmt
    fp16
    gcc-unwrapped.lib
    httplib
    jsoncpp
    libarchive
    libcpr
    libnop
    libusb1
    lz4
    magic-enum
    neargye-semver
    nlohmann_json
    openssl
    pcl
    protobuf_21
    spdlog
    trompeloeil
    websocketpp
    xlink
    xtensor
    xz
    yaml-cpp
    zlib
  ]
  ++ lib.optional opencvSupport (
    opencv4.override {
      enableGtk2 = true;
      enableGtk3 = true;
    }
  );

  propagatedBuildInputs = lib.optionals buildPython (
    with python3Packages;
    [
      numpy
      pybind11
    ]
  );

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!(stdenv.hostPlatform.isStatic)))

    (lib.cmakeBool "DEPTHAI_VCPKG_INTERNAL_ONLY" false)
    (lib.cmakeBool "DEPTHAI_BOOTSTRAP_VCPKG" false)

    # Depend on internet access
    (lib.cmakeBool "DEPTHAI_DYNAMIC_CALIBRATION_SUPPORT" false)
    (lib.cmakeBool "DEPTHAI_ENABLE_REMOTE_CONNECTION" false)
    (lib.cmakeBool "DEPTHAI_FETCH_ARTIFACTS" false)

    # Do not have CMake file under /lib
    (lib.cmakeBool "DEPTHAI_ENABLE_CURL" false)
    (lib.cmakeBool "DEPTHAI_ENABLE_MP4V2" false)

    (lib.cmakeBool "DEPTHAI_BUILD_EXAMPLES" buildExamples)
    (lib.cmakeBool "DEPTHAI_BUILD_PYTHON" buildPython)
    (lib.cmakeBool "DEPTHAI_BUILD_TESTS" buildTests)
    (lib.cmakeBool "DEPTHAI_BASALT_SUPPORT" basaltSupport)
    (lib.cmakeBool "DEPTHAI_OPENCV_SUPPORT" opencvSupport)
    (lib.cmakeBool "DEPTHAI_PCL_SUPPORT" pclSupport)
    (lib.cmakeBool "DEPTHAI_RTABMAP_SUPPORT" rtabmapSupport)
    (lib.cmakeBool "DEPTHAI_XTENSOR_SUPPORT" xtensorSupport)
  ];

  postPatch = ''
    mkdir -p $TMP/source/build/resources
    cp ${depthai-data}/share/resources/* $TMP/source/build/resources
  '';

  meta = {
    description = "DepthAI C++ library for interfacing with Luxonis DepthAI hardware.";
    homepage = "https://github.com/luxonis/depthai-core";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      amronos
    ];
  };
})
