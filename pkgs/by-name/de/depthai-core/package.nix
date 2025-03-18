{
  lib,
  stdenv,
  fetchurl,
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
  magic-enum,
  nlohmann_json,
  libnop,
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
  fp16,
  curl,
  cpr,
  xtl,
  fmt,
  zlib,
  depthai-data,
  ws-protocol,
# FIXME: Build dependencies first
#  basalt,
#  rtabmap,
}:

let
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

  inherit (python3Packages)
    numpy
    mypy
    pybind11
    pybind11-stubgen
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "depthai-core";
  version = "3.0.0-alpha.14";

  src = fetchFromGitHub {
    owner = "luxonis";
    repo = "depthai-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ayd4kwcOJewIGmfuSu8Hs91YPfcxOSmIK5RfLMVbTk8=";
    fetchSubmodules = true;
  };

  patches = [
    ./0001-CMakeLists.txt-Fix-dependencies.patch
    ./0002-CMakeLists.txt-Add-embedded-dependencies.patch
    ./0003-CMakeLists.txt-Link-crypto-library-due-to-OpenSSL-re.patch
    ./0004-CMakeLists-backward-dependency.patch
    ./0005-CMakeLists-Do-not-install-3rdparty-source-code.patch
    ./0006-cmake-Disable-downloaders-for-container-build.patch
    ./0007-cmake-Sort-out-dependencies-for-depthai.patch
    ./0008-examples-Don-t-download-dependencies.patch
    ./0009-Color.hpp-Explicit-specification-for-float-type.patch
    ./0010-StreamMessageParser.cpp-Add-case-for-DatatypeEnum-Im.patch
    ./0011-BenchmarkOut.cpp-Explicit-cast-to-double.patch
    ./0012-cmake-Handle-catch2-dependencies-for-tests.patch
    ./0013-cmake-Don-t-download-the-test-dependencies.patch
    ./0014-cmake-Install-examples-after-build-WIP.patch
    ./0015-magic-enum.patch
    ./016-resources.patch
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
    opencv4WithGtk
    xorg.libX11
    httplib
    openssl
    (if stdenv.isDarwin then protobuf_21 else protobuf)
    cproto
    xtensor
    xtl
    magic-enum
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
    curl
    mp4v2
    pcl
    eigen
    jsoncpp
    fmt
    libarchive
    bzip2
    lz4
    xz
    zlib
    depthai-data
    ws-protocolCompat
    catch2_3WithSharedLibs
# FIXME: Build dependencies first
#  basalt,
#  rtabmap,
  ];

  propagatedBuildInputs = [
    numpy
    pybind11
    pybind11-stubgen
    mypy
    pyOpencv4WithGtk
  ];

  cmakeFlags = [
    (lib.cmakeBool "DEPTHAI_BOOTSTRAP_VCPKG" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "DEPTHAI_BUILD_EXAMPLES" true)
    (lib.cmakeBool "DEPTHAI_TEST_EXAMPLES" true)
    (lib.cmakeBool "DEPTHAI_PCL_SUPPORT" true)
    (lib.cmakeBool "DEPTHAI_BUILD_TESTS" true)
    (lib.cmakeBool "DEPTHAI_BUILD_PYTHON" true)
    (lib.cmakeBool "DEPTHAI_PYTHON_ENABLE_TESTS" true)
    # NOTE: Dependency broken
    #    (lib.cmakeBool "DEPTHAI_BASALT_SUPPORT" true)
    # NOTE: Broken atm
    #(lib.cmakeBool "DEPTHAI_RTABMAP_SUPPORT" true)
  ];

  # Add rpath to all executables to find the libraries
  postFixup = ''
    mkdir -p $out/share/
    mkdir -p $out/lib/
    mkdir -p $out/${python3.sitePackages}
    mkdir -p $out/share/python-examples
    name=$(basename $TMP)

    # Copy any additional Python files if they're not already in the right place
    ${if stdenv.isDarwin then ''
    if [ -d /tmp/$name/source/build/bindings/python ]; then
       cp -r /tmp/$name/source/build/bindings/python/depthai $out/${python3.sitePackages}/
    '' else ''
    if [ -d $buildDir/build/source/build/bindings/python ]; then
       cp -r $buildDir/build/source/build/bindings/python/depthai $out/${python3.sitePackages}/
    ''}
       mkdir -p $out/${python3.sitePackages}/depthai_cli
       cp $src/bindings/python/utilities/stress_test.py $out/${python3.sitePackages}/depthai_cli
       cp $src/bindings/python/utilities/cam_test.py $out/${python3.sitePackages}/depthai_cli
       cp $src/bindings/python/depthai_cli/__init__.py $out/${python3.sitePackages}/depthai_cli
       cp $src/bindings/python/depthai_cli/depthai_cli.py $out/${python3.sitePackages}/depthai_cli
    fi

    # Copy Python examples
    cp -r $src/examples/python/* $out/share/python-examples

    # Find all shared libraries in the build directory and copy them to lib directory
    ${if stdenv.isDarwin then ''
    find $buildDir -name "*.dylib*" -type f -not -path "*/\.*" | while read lib_file; do
    '' else ''
    find $buildDir -name "*.so*" -type f -not -path "*/\.*" | while read lib_file; do
    ''}
      cp -P "$lib_file" $out/lib/
    done

    # Find all shared libraries in the build directory and copy them to lib directory
    # Exclude static libraries (.a files) and only copy shared objects (.so files)
    ${if stdenv.isDarwin then ''
    find $buildDir -name "*.dylib*" -type f -not -name "*.a" -not -path "*/\.*" | while read lib_file; do
    '' else ''
    find $buildDir -name "*.so*" -type f -not -name "*.a" -not -path "*/\.*" | while read lib_file; do
    ''}
      lib_basename=$(basename "$lib_file")
      if [ ! -e "$out/lib/$lib_basename" ]; then
        cp -P "$lib_file" $out/lib/
      else
        echo "Skipping $lib_basename as it already exists in $out/lib/"
      fi
    done

    # Find all executables in the build directory and copy them to share
    find $buildDir -type f -executable -not -path "*/\.*" | while read exec_file; do
      cp "$exec_file" $out/share/
    done

    # Patch the executables in the share directory
    for f in $out/share/*; do
      if [ -f "$f" ] && [ -x "$f" ]; then
        echo "Patching $f"
        ${if stdenv.isDarwin then ''
          install_name_tool -add_rpath $out/lib $f || true
        '' else ''
        patchelf --set-rpath "${lib.makeLibraryPath finalAttrs.buildInputs}:$out/lib" "$f" || true
        ''}
      fi
    done

    # Also patch the binaries in the bin directory
    for f in $out/bin/*; do
      if [ -f "$f" ] && [ -x "$f" ]; then
        echo "Patching $f"
        ${if stdenv.isDarwin then ''
          install_name_tool -add_rpath $out/lib $f || true
        '' else ''
          patchelf --set-rpath "${lib.makeLibraryPath finalAttrs.buildInputs}:$out/lib" "$f" || true
        ''}
      fi
    done

    # Make Python Great again
    ${if stdenv.isDarwin then ''
      mv bindings/python/depthai.cpython-312-darwin.so $out/${python3.sitePackages}/
      install_name_tool -add_rpath $out/lib $out/${python3.sitePackages}/depthai.cpython-312-darwin.so

      mv bindings/python/tests/depthai_pybind11_tests.cpython-312-darwin.so $out/${python3.sitePackages}/
      install_name_tool -add_rpath $out/lib $out/${python3.sitePackages}/depthai_pybind11_tests.cpython-312-darwin.so 
    '' else ''
      mv $out/lib/depthai.cpython-312-x86_64-linux-gnu.so $out/${python3.sitePackages}/
      mv $out/lib/depthai_pybind11_tests.cpython-312-x86_64-linux-gnu.so $out/${python3.sitePackages}/
    ''}
  '';

  postPatch = if stdenv.isDarwin then ''
    name=$(basename $TMP)
    substituteInPlace CMakeLists.txt --replace-fail "@NIX_PATH@" "/tmp/$name/source/build/resources/"
 
    mkdir -p /tmp/$name/source/build/resources
     # NOTE: Replace with symlink?
    cp ${depthai-data}/share/resources/* /tmp/$name/source/build/resources

    # Remove 3rdparty directory
    rm -rf 3rdparty
'' else  ''
    substituteInPlace CMakeLists.txt --replace-fail "@NIX_PATH@" "/build/source/build/resources/"

    mkdir -p /build/source/build/resources
    # NOTE: Replace with symlink?
    cp ${depthai-data}/share/resources/* /build/source/build/resources

    # Remove 3rdparty directory
    rm -rf 3rdparty
  '';

  meta = {
    description = "Core C++ library for Luxonis OAK devices";
    homepage = "https://github.com/luxonis/depthai-core";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ phodina ];
  };
})
