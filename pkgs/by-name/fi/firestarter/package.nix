{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchzip,
  addDriverRunpath,
  cmake,
  glibc_multi,
  glibc,
  git,
  pkg-config,
  installShellFiles,
  config,
  cudaPackages,
  versionCheckHook,
  withCuda ? config.cudaSupport,
}:

let
  hwloc = stdenv.mkDerivation (finalAttrs: {
    pname = "hwloc";
    version = "2.2.0";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchzip {
      url = "https://download.open-mpi.org/release/hwloc/v${lib.versions.majorMinor finalAttrs.version}/hwloc-${finalAttrs.version}.tar.gz";
      hash = "sha256-ZgHkj1kJR9Fk1UD8Vv0syKZk7kba81nr+OjdmyAJfMU=";
    };

    configureFlags = [
      "--enable-static"
      "--disable-libudev"
      "--disable-shared"
      "--disable-doxygen"
      "--disable-libxml2"
      "--disable-cairo"
      "--disable-io"
      "--disable-pci"
      "--disable-opencl"
      "--disable-cuda"
      "--disable-nvml"
      "--disable-gl"
      "--disable-libudev"
      "--disable-plugin-dlopen"
      "--disable-plugin-ltdl"
    ];

    nativeBuildInputs = [ pkg-config ];

    enableParallelBuilding = true;

    outputs = [
      "out"
      "lib"
      "dev"
      "doc"
      "man"
    ];
  });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "firestarter";
  version = "2.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tud-zih-energy";
    repo = "FIRESTARTER";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Q1jIvcuiAUzyF0v32beIqZLyMPeZUjoikY3awmmQZsY=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'set(_FIRESTARTER_VERSION_STRING "unknown")' \
        'set(_FIRESTARTER_VERSION_STRING "v${finalAttrs.version}")'

    substituteInPlace lib/nitro/CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.2)' \
        'cmake_minimum_required(VERSION 3.10)'

    substituteInPlace lib/json/CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.1)' \
        'cmake_minimum_required(VERSION 3.10)'
  '';

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    installShellFiles
  ]
  ++ lib.optionals withCuda [
    addDriverRunpath
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    hwloc
  ]
  ++ (
    if withCuda then
      [
        glibc_multi
        cudaPackages.cuda_nvcc # crt/host_defines.h
        cudaPackages.cuda_cudart
        cudaPackages.libcublas
        cudaPackages.libcurand
      ]
    else
      [ glibc.static ]
  );

  env = lib.optionalAttrs withCuda {
    NIX_LDFLAGS = "-L${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs";
  };

  cmakeFlags = [
    (lib.cmakeBool "FIRESTARTER_BUILD_HWLOC" false)
    (lib.cmakeFeature "CMAKE_C_COMPILER_WORKS" "1")
    (lib.cmakeFeature "CMAKE_CXX_COMPILER_WORKS" "1")
  ]
  ++ lib.optionals withCuda [
    (lib.cmakeFeature "FIRESTARTER_BUILD_TYPE" "FIRESTARTER_CUDA")
  ];

  installPhase = ''
    runHook preInstall
    installBin src/FIRESTARTER${lib.optionalString withCuda "_CUDA"}
    runHook postInstall
  '';

  doInstallCheck = !withCuda; # tries to access GPU
  nativeInstallCheckInputs = [ versionCheckHook ];

  postFixup = lib.optionalString withCuda ''
    addDriverRunpath $out/bin/FIRESTARTER_CUDA
  '';

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    homepage = "https://tu-dresden.de/zih/forschung/projekte/firestarter";
    description = "Processor Stress Test Utility";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      astro
      marenz
    ];
    license = lib.licenses.gpl3;
    mainProgram = "FIRESTARTER${lib.optionalString withCuda "_CUDA"}";
  };
})
