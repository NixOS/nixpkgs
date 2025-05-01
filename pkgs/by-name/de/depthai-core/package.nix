{
  lib,
  pkgs,
  stdenv,
  fetchpatch,
  fetchurl,
  fetchzip,
  fetchFromGitHub,
  cmake,
  gcc,
  gcc-unwrapped,
  clang-tools,
  pkg-config,
  libusb1,
  opencv4,
  boost186,
  libpng,
  libarchive,
  httplib,
  openssl,
  protobuf,
  protobuf_21,
  xtensor,
  cproto,
  eigen,
  yaml-cpp,
  jsoncpp,
  spdlog,
  argparse,
  nlohmann_json,
  libnop,
  mcap,
  websocketpp,
  mp4v2,
  neargye-semver,
  backward-cpp,
  pcl,
  python3,
  python3Packages,
  catch2_3,
  xorg,
  git,
  bzip2,
  lz4,
  xz,
  apriltag,
  xlink,
  magic-enum,
  fp16,
  curl,
  cpr,
  xtl,
  fmt,
  zlib,
  depthai-data,
  ws-protocol,
}:

let
  arch = builtins.elemAt (builtins.split "-" stdenv.hostPlatform.system) 0;

  catch2_3WithSharedLibs = catch2_3.overrideAttrs (oldAttrs: {
    cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
      "-DBUILD_SHARED_LIBS=ON"
    ];
  });

  # Latest commits are not compatible, use older version
  ws-protocolCompat = ws-protocol.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "foxglove";
      repo = "ws-protocol";
      rev = "e8440dbc988efb42ad206fd3e2e46f4eb2e5f5c0";
      hash = "sha256-jPFSN2edGE0ge8AWFvIeXfoXn9JcAcLOTfsBcJq+dUo=";
    };

    patches = [ ./001-Ws-protocol-add-missing-libs.patch ];
  });

  # Latest commits are not compatible, use older version
  xlinkCompat = xlink.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "Luxonis";
      repo = "xlink";
      rev = "7f5633ab542df632acaf4ccaf5e98d30f984e6e4";
      hash = "sha256-jZQhH4xZgwM/439GkOr28Xrh1D18vh3jMPiRJR8WdD0=";
    };

    patches = [ ./001-Xlink-Remove-Hunter.patch ];

    postInstall = ''
      mkdir -p $out/include
      mkdir -p $share/examples
      mkdir -p $share/tests

      cp -r $src/include/* $out/include/

      examples=(
        "boot_firmware"
        "list_devices"
        "boot_bootloader"
        "search_devices"
        "Makefile"
        "device_connect_reset"
      )

      find $buildDir
      for file in "''${examples[@]}"; do
        cp examples/$file $share/examples/$file
      done
    '';
  });

  opencv4WithGtk = opencv4.override {
    enableGtk2 = true; # For GTK2 support
    enableGtk3 = true; # For GTK3 support
  };

  pyOpencv4WithGtk = python3Packages.opencv4.override {
    enableGtk2 = true; # For GTK2 support
    enableGtk3 = true; # For GTK3 support
  };

  rerun_sdk = fetchzip {
    url = "https://github.com/rerun-io/rerun/releases/download/0.16.1/rerun_cpp_sdk.zip";
    hash = "sha256-tYwcRjlU8m+OHkwdbQeM+X5outF0NFbj8Ee3y5h9+l0=";
    stripRoot = false; # Important for zip files to preserve the directory structure
  };

  samplesLib = pkgs.callPackage ./samples.nix { };

  inherit (python3Packages)
    numpy
    mypy
    docformatter
    pybind11
    pybind11-stubgen
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "depthai-core";
  version = "3.0.0-alpha.15";

  src = fetchFromGitHub {
    owner = "luxonis";
    repo = "depthai-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kEULv+9S9dV5qu2ienh/WmxtQjS3cVV3yC5Q9zTf7ZQ=";
    fetchSubmodules = true;
  };

  patches = [
    # Offine build
    (fetchpatch {
      url = "https://github.com/luxonis/depthai-core/pull/1303/commits/cc8fd0fe76b460b512a515e8c3a2919fa72358c8.patch";
      hash = "sha256-0v3KhRzod89gG4ce2m1G+ie3iW4IYnztKZ3cwKb/MG0=";
    })
    # CMake system install and fix RPATH
    (fetchpatch {
      url = "https://github.com/luxonis/depthai-core/pull/1309/commits/0571499c79658afb5112bd6c3488a649dc045d64.patch";
      hash = "sha256-4ctLBhnD6Vzy4Si+OFnyUXCQ0wkt7630UDnk7odww0c=";
    })

    ./0002-cmake-Fix-build-dependencies.patch
    ./0003-cmake-Skip-some-dependencies.patch
    ./0004-cmake-Enable-build-of-3rdparty-dependencies.patch
    ./0005-magic-enum.patch
    ./0006-skip-libnop-xtensor.patch
    ./0007-we-still-need-thirdparty.patch

    # BechmarkOut.cpp fix cast to double
    (fetchpatch {
      url = "https://github.com/luxonis/depthai-core/pull/1302/commits/aa51312342906f321ba34c07f405a413c231e50c.patch";
      hash = "sha256-YgniRH8qPwUzhIUXSAD0AO7K8Wlce4rZD6BUn/a09bU=";
    })
    # Color.hpp fix cast to float
    (fetchpatch {
      url = "https://github.com/luxonis/depthai-core/pull/1302/commits/4abe505665bcc606161b4574a25dcbfd643b8fb9.patch";
      hash = "sha256-y99LZvAWJTO3co8UPj9OFrfwmmawbNwTHSyb+dp1F/I=";
    })
  ];

  nativeBuildInputs = [
    cmake
    clang-tools
    git
    pkg-config
  ];

  buildInputs = [
    gcc-unwrapped.lib # provides libstdc++.so.6
    argparse
    boost186
    libusb1
    libpng
    magic-enum
    opencv4WithGtk
    xorg.libX11
    httplib
    openssl
    (if stdenv.isDarwin then protobuf_21 else protobuf)
    cproto
    xtensor
    xtl
    samplesLib
    nlohmann_json
    libnop
    websocketpp
    mp4v2
    neargye-semver
    backward-cpp
    spdlog
    yaml-cpp
    apriltag
    xlinkCompat
    cpr
    fp16
    curl.dev
    mp4v2
    pcl
    eigen
    jsoncpp
    fmt
    mcap
    libarchive
    bzip2
    lz4
    xz
    zlib
    depthai-data
    ws-protocolCompat
    catch2_3WithSharedLibs
  ];

  propagatedBuildInputs = [
    numpy
    pybind11
    pybind11-stubgen
    docformatter
    mypy
    pyOpencv4WithGtk
  ];

  cmakeFlags = [
    (lib.cmakeBool "DEPTHAI_FETCH_ARTIFACTS" false)
    (lib.cmakeBool "DEPTHAI_3RDPARTY_ENABLE" false)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RERUN_SDK" "${rerun_sdk}")
    (lib.cmakeFeature "CMAKE_INCLUDE_PATH" "include/3rdparty")
    (lib.cmakeBool "DEPTHAI_BOOTSTRAP_VCPKG" false)
    (lib.cmakeBool "DEPTHAI_BOOTSTRAP_VCPKG" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "DEPTHAI_PCL_SUPPORT" true)
    (lib.cmakeBool "DEPTHAI_BUILD_PYTHON" true)
    (lib.cmakeBool "DEPTHAI_PYTHON_ENABLE_TESTS" true)
    (lib.cmakeBool "DEPTHAI_INSTALL" true)

    # NOTE: Not yet packaged
    (lib.cmakeBool "DEPTHAI_BASALT_SUPPORT" false)

    # NOTE: MR to fix the broken package
    (lib.cmakeBool "DEPTHAI_RTABMAP_SUPPORT" false)

    # NOTE: Does not have CMake file under /lib
    (lib.cmakeBool "DEPTHAI_ENABLE_CURL" false)

    (lib.cmakeBool "DEPTHAI_ENABLE_BACKWARD" true)

    # Note: as they run in parallel they require lot of RAM
    (lib.cmakeBool "DEPTHAI_BUILD_TESTS" true)
    (lib.cmakeBool "DEPTHAI_TEST_EXAMPLES" true)

    # Fixme: requires 'rerun.hpp' which is part of rerun_cpp_sdk.zip
    (lib.cmakeBool "DEPTHAI_BUILD_EXAMPLES" false)
  ];

  postPatch =
    if stdenv.isDarwin then
      ''
        name=$(basename $TMP)
        #substituteInPlace CMakeLists.txt --replace-fail "@NIX_PATH@" "/tmp/$name/source/build/resources/"

        mkdir -p /tmp/$name/source/build/resources
         # NOTE: Replace with symlink?
        cp ${depthai-data}/share/resources/* /tmp/$name/source/build/resources

        # Remove all but nanorpc in 3rdparty directory
        find 3rdparty -maxdepth 1 -type d -not -name "." -not -name "nanorpc" -exec rm -rf {} \;
      ''
    else
      ''
        #substituteInPlace CMakeLists.txt --replace-fail "@NIX_PATH@" "/build/source/build/resources/"

        mkdir -p /build/source/build/resources
        # NOTE: Replace with symlink?
        cp ${depthai-data}/share/resources/* /build/source/build/resources

        # Remove all but nanorpc in 3rdparty directory
        cd include/3rdparty
        find . -maxdepth 1 -type d -not -name "." -not -name "nanorpc" -exec rm -rf {} \;
        cd ../..
      '';

  meta = {
    description = "Core C++ library for Luxonis OAK devices";
    homepage = "https://github.com/luxonis/depthai-core";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ phodina ];
  };
})
