{ stdenv
, fetchFromGitHub
, cmake
, pkgs
, tree
, cudaPackages ? { }
}:

with cudaPackages;

let
  libcudaDir = "/run/opengl-driver/lib";
  inherit (cudaPackages)
    autoAddOpenGLRunpathHook
    backendStdenv
    cudaFlags;

  inherit (cudaFlags) dropDot cudaCapabilities;

  CUDA_ARCH = builtins.concatStringsSep ";" (map dropDot cudaCapabilities);
in
backendStdenv.mkDerivation rec {

  version = "6.17.0";
  pname = "xmrig-cuda";
  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig-cuda";
    rev = "v${version}";
    sha256 = "sha256-vRVLmMgCG42btm0jcteZiftchjRZotBgT98znQV0I+k=";
  };

  nativeBuildInputs = [
    cmake
    autoAddOpenGLRunpathHook
    cuda_nvcc
    cuda_cccl
  ];

  buildInputs = [
    cuda_cudart
    cuda_nvrtc
  ];

  cmakeFlags = [
    "WITH_CUDA=ON"
    "WITH_NVML=ON"
    # "-DCUDA_TOOLKIT_ROOT_DIR=${cudatoolkit}"
    # "-DLIBCUDA_LIBRARY_DIR=${libcudaDir}"
    "-DCUDA_LIB=${cuda_cudart}/lib/stubs/libcuda.so"
    # "-DCUDA_CUDA_LIBRARY=${libcudaDir}/libcuda.so"
    # "-DCUDA_CUDART_LIBRARY=${cuda_cudart}/lib/libcudart.so"
    # "-DLIBNVRTC_LIBRARY_DIR=${cudatoolkit}/lib"
    # "-DCUDA_NVRTC_LIB=${cudatoolkit}/lib/libnvrtc.so" # or from cuda_nvrtc?
    "-DCUDA_ARCH=${CUDA_ARCH}"
  ];

  installPhase = ''
    install -Dm644 libxmrig-cuda.so $out/lib/libxmrig-cuda.so
  '';
}
