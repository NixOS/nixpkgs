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
  config,
  cudaPackages,
  withCuda ? config.cudaSupport,
}:

let
  hwloc = stdenv.mkDerivation rec {
    pname = "hwloc";
    version = "2.2.0";

    src = fetchzip {
      url = "https://download.open-mpi.org/release/hwloc/v${lib.versions.majorMinor version}/hwloc-${version}.tar.gz";
      sha256 = "1ibw14h9ppg8z3mmkwys8vp699n85kymdz20smjd2iq9b67y80b6";
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
  };

in
stdenv.mkDerivation rec {
  pname = "firestarter";
  version = "2.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tud-zih-energy";
    repo = "FIRESTARTER";
    tag = "v${version}";
    hash = "sha256-Q1jIvcuiAUzyF0v32beIqZLyMPeZUjoikY3awmmQZsY=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace lib/nitro/CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 3.2)' 'cmake_minimum_required(VERSION 3.10)'
    substituteInPlace lib/json/CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 3.1)' 'cmake_minimum_required(VERSION 3.10)'
  '';

  nativeBuildInputs = [
    cmake
    git
    pkg-config
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
    "-DFIRESTARTER_BUILD_HWLOC=OFF"
    "-DCMAKE_C_COMPILER_WORKS=1"
    "-DCMAKE_CXX_COMPILER_WORKS=1"
  ]
  ++ lib.optionals withCuda [
    "-DFIRESTARTER_BUILD_TYPE=FIRESTARTER_CUDA"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp src/FIRESTARTER${lib.optionalString withCuda "_CUDA"} $out/bin/
    runHook postInstall
  '';

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
    mainProgram = "FIRESTARTER";
  };
}
