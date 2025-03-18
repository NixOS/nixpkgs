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
  nanorpc,
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

  prefixVar = "\${" + "prefix}";
  # Latest commits are not compatible, use older version
  xtensorCompat = xtensor.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "xtensor-stack";
      repo = "xtensor";
      rev = "825c0fd8a465049c06ad89fa3911b342dbffcabf";
      hash = "sha256-gg1R/4ykdOQOpNzKUViaCdybvIXosJobduIagRv/15E=";
    };

    preConfigure = ''
      echo "Fixing xtensor.pc.in for Nix compatibility..."
      find . -name xtensor.pc.in -exec sed -i 's|${prefixVar}/@CMAKE_INSTALL_LIBDIR@|@CMAKE_INSTALL_FULL_LIBDIR@|g' {} \;
    '';
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
  version = "3.0.0-beta.1";

  src = fetchFromGitHub {
    owner = "luxonis";
    repo = "depthai-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I8R+sdF0QWvJEQxaP8b9sncW3fOooyv8LKmRqRAX42c=";
    fetchSubmodules = true;
  };

  patches = [
    # Offine build
    (fetchpatch {
      url = "https://github.com/luxonis/depthai-core/pull/1303/commits/5340a086445282f121dfe25966e00bf13dd4ef67.patch";
      hash = "sha256-JoNaYJ4j7upBLvf2tfQE5Fh7KRr2FO+is0eselzqwIE=";
    })
    # CMake system install and fix RPATH
    (fetchpatch {
      url = "https://github.com/luxonis/depthai-core/pull/1309/commits/3caf449df59ea245797f4363da53149ef2978897.patch";
      hash = "sha256-J2NrGjWMeH4ks9cSfa+vtm4UTRM7Wp//0F/q+u/aKCs=";
    })

    ./0001-nixos-specific-patches.patch
    ./0002-cmake-Add-option-to-enable-3rdparty-dependencies.patch

    # NOTE: Already merged in 'v3_develop' https://github.com/luxonis/depthai-core/pull/1329
    ./0003-fix-include-directory-tests.patch
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
    libusb1.dev
    libpng
    magic-enum
    opencv4WithGtk
    xorg.libX11
    httplib
    openssl
    protobuf_21
    cproto
    xtensorCompat
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
    nanorpc
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
    (lib.cmakeBool "DEPTHAI_ENABLE_LIBUSB" true)
    (lib.cmakeBool "DEPTHAI_XLINK_LOCAL" false)
    (lib.cmakeBool "DEPTHAI_FETCH_ARTIFACTS" false)
    (lib.cmakeBool "DEPTHAI_ENABLE_3RDPARTY" false)
    (lib.cmakeBool "DEPTHAI_ENABLE_FW_DOWNLOAD" false)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RERUN_SDK" "${rerun_sdk}")
    (lib.cmakeFeature "CMAKE_INCLUDE_PATH" "include/3rdparty")
    (lib.cmakeBool "DEPTHAI_BOOTSTRAP_VCPKG" false)
    (lib.cmakeBool "DEPTHAI_BOOTSTRAP_VCPKG" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "DEPTHAI_PCL_SUPPORT" true)
    (lib.cmakeBool "DEPTHAI_XTENSOR_SUPPORT" true)
    (lib.cmakeBool "DEPTHAI_XTENSOR_EXTERNAL" true)
    (lib.cmakeBool "DEPTHAI_JSON_EXTERNAL" true)
    (lib.cmakeBool "DEPTHAI_LIBNOP_EXTERNAL" true)
    (lib.cmakeBool "DEPTHAI_BUILD_PYTHON" true)
    (lib.cmakeBool "DEPTHAI_PYTHON_ENABLE_TESTS" true)
    (lib.cmakeBool "DEPTHAI_INSTALL" true)

    (lib.cmakeBool "DEPTHAI_ENABLE_MP4V2" false)

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
