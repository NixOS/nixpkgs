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
  version = "25.18.33578.6";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "compute-runtime";
    tag = version;
    hash = "sha256-6HJUwoMzd8T9o0dohLiXz2xwtqnUmkFuftIUPqKpy5s=";
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

  meta = with lib; {
    description = "Intel Graphics Compute Runtime oneAPI Level Zero and OpenCL, supporting 12th Gen and newer";
    mainProgram = "ocloc";
    homepage = "https://github.com/intel/compute-runtime";
    changelog = "https://github.com/intel/compute-runtime/releases/tag/${version}";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
