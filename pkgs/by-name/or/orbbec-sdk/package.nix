{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gcc-unwrapped,
  libusb1,
  libuvc,
  opencv4,
  eigen,
  pcl,
  boost,
  openssl,
  zlib,
  libpng,
  libjpeg,
  abseil-cpp,
  tbb,
  jansson,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orbbec-sdk";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "orbbec";
    repo = "OrbbecSDK_v2";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-HfdOzh/QdzpET2YTEA9PfrqdmVEMqY+P3oCSpfR1kqA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gcc-unwrapped
    libusb1
    libuvc
    opencv4
    eigen
    pcl
    boost
    openssl
    zlib
    libpng
    libjpeg
    abseil-cpp
    tbb
    jansson
  ];

  cmakeFlags = [
    (lib.cmakeBool "OB_ENABLE_EXAMPLE" true)
    (lib.cmakeBool "OB_BUILD_TOOLS" true)
    (lib.cmakeBool "OB_BUILD_TEST" false)
  ];

  # Make sure USB rules are installed
  postInstall = ''
    # Install udev rules
    mkdir -p $out/lib/udev/rules.d
    if [ -f $src/CMake/99-orbbec.rules ]; then
      cp $src/CMake/99-orbbec.rules $out/lib/udev/rules.d/
    elif [ -f $src/scripts/99-orbbec.rules ]; then
      cp $src/scripts/99-orbbec.rules $out/lib/udev/rules.d/
    fi

    # Copy all examples to a share directory
    mkdir -p $out/share/${finalAttrs.pname}/examples
    if [ -d $buildDir/examples ]; then
      find $buildDir/examples -type f -executable -not -path "*/\.*" | while read exec_file; do
        cp "$exec_file" $out/share/${finalAttrs.pname}/examples/
      done
    fi
  '';

  # Fix library paths for the executables
  postFixup = ''
    # Find all shared libraries and make sure they're included in the runtime path
    mkdir -p $out/lib/${finalAttrs.pname}

    # Copy any shared libraries from the build directory
    find $buildDir -name "*.so*" -type f -not -name "*.a" -not -path "*/\.*" | while read lib_file; do
      lib_basename=$(basename "$lib_file")
      if [ ! -e "$out/lib/${finalAttrs.pname}/$lib_basename" ]; then
        cp -P "$lib_file" $out/lib/${finalAttrs.pname}/
      fi
    done

    # Create symlinks in the main lib directory if they don't exist
    for lib_file in $out/lib/${finalAttrs.pname}/*.so*; do
      if [ -f "$lib_file" ]; then
        lib_basename=$(basename "$lib_file")
        if [ ! -e "$out/lib/$lib_basename" ]; then
          ln -sf "$lib_file" $out/lib/
        fi
      fi
    done

    # Fix rpath for all executables in bin and share/examples
    for bin_dir in "$out/bin" "$out/share/${finalAttrs.pname}/examples"; do
      if [ -d "$bin_dir" ]; then
        for f in $bin_dir/*; do
          if [ -f "$f" ] && [ -x "$f" ]; then
            echo "Patching $f"
            patchelf --set-rpath "${lib.makeLibraryPath finalAttrs.buildInputs}:$out/lib:$out/lib/${finalAttrs.pname}" "$f" || true
          fi
        done
      fi
    done

    # Create summary files
    ls -la $out/bin > $out/share/${finalAttrs.pname}/binary_list.txt || true
    ls -la $out/lib/${finalAttrs.pname} > $out/share/${finalAttrs.pname}/library_list.txt || true
    if [ -d "$out/share/${finalAttrs.pname}/examples" ]; then
      ls -la $out/share/${finalAttrs.pname}/examples > $out/share/${finalAttrs.pname}/examples_list.txt || true
    fi
  '';

  meta = {
    description = "Orbbec SDK v2 for 3D cameras and depth sensors";
    homepage = "https://github.com/orbbec/OrbbecSDK_v2";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ phodina ];
  };
})
