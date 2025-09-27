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
}:

stdenv.mkDerivation rec {
  pname = "intel-compute-runtime";
  version = "25.35.35096.9";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "compute-runtime";
    tag = version;
    hash = "sha256-GAFbpf5ZUpq+jpVECa5buauCYdpPBOBrREkgrGyhxPA=";
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
    (lib.cmakeBool "SKIP_UNIT_TESTS" true)
    (lib.cmakeFeature "IGC_DIR" (builtins.toString intel-graphics-compiler))
    (lib.cmakeFeature "OCL_ICD_VENDORDIR" "${placeholder "out"}/etc/OpenCL/vendors")
    # The install script assumes this path is relative to CMAKE_INSTALL_PREFIX
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    # disable spectre mitigations (already mitigated in the kernel)
    # https://bugs.launchpad.net/ubuntu/+source/intel-compute-runtime/+bug/2110131
    (lib.cmakeBool "NEO_DISABLE_MITIGATIONS" true)
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

  meta = {
    description = "Intel Graphics Compute Runtime oneAPI Level Zero and OpenCL, supporting 12th Gen and newer";
    mainProgram = "ocloc";
    homepage = "https://github.com/intel/compute-runtime";
    changelog = "https://github.com/intel/compute-runtime/releases/tag/${version}";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
