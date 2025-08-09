{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  intel-gmmlib,
  intel-graphics-compiler,
  level-zero,
  libva,
  gitUpdater,
}:

let
  inherit (lib) cmakeBool;
in
stdenv.mkDerivation rec {
  # https://github.com/intel/compute-runtime/blob/master/LEGACY_PLATFORMS.md
  pname = "intel-compute-runtime-legacy1";
  version = "24.35.30872.32"; # 24.35.30872.x is the last series to support Gen8, Gen9 and Gen11 GPU support

  src = fetchFromGitHub {
    owner = "intel";
    repo = "compute-runtime";
    rev = version;
    hash = "sha256-POImMopbrhVXuSx2MQ9mwPNKQx7BljyikKhu6M4hZME=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    intel-gmmlib
    intel-graphics-compiler
    libva
    level-zero
  ];

  cmakeFlags = [
    "-DSKIP_UNIT_TESTS=1"
    "-DIGC_DIR=${intel-graphics-compiler}"
    "-DOCL_ICD_VENDORDIR=${placeholder "out"}/etc/OpenCL/vendors"
    # The install script assumes this path is relative to CMAKE_INSTALL_PREFIX
    "-DCMAKE_INSTALL_LIBDIR=lib"
    (cmakeBool "NEO_LEGACY_PLATFORMS_SUPPORT" true)
  ];

  outputs = [
    "out"
    "drivers"
  ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  postInstall = ''
    # Avoid clash with intel-ocl
    mv $out/etc/OpenCL/vendors/intel.icd $out/etc/OpenCL/vendors/intel-neo.icd

    mkdir -p $drivers/lib
    mv -t $drivers/lib $out/lib/libze_intel*
  '';

  postFixup = ''
    patchelf --set-rpath ${
      lib.makeLibraryPath [
        intel-gmmlib
        intel-graphics-compiler
        libva
        stdenv.cc.cc
      ]
    } \
      $out/lib/intel-opencl/libigdrcl.so
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "24.35.30872.";
  };

  meta = {
    description = "Intel Graphics Compute Runtime oneAPI Level Zero and OpenCL with support for Gen8, Gen9 and Gen11 GPUs";
    mainProgram = "ocloc";
    homepage = "https://github.com/intel/compute-runtime";
    changelog = "https://github.com/intel/compute-runtime/releases/tag/${version}";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ fleaz ];
  };
}
