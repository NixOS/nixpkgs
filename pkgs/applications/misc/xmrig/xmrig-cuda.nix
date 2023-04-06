{ stdenv
, fetchFromGitHub
, cmake
, pkgs
, tree
, cudaPackages ? { }
}:

with cudaPackages;

let
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
    cuda_nvcc
    cuda_cccl
    autoAddOpenGLRunpathHook
  ];

  buildInputs = [
    cuda_cudart
    cuda_nvrtc
  ];

  cmakeFlags = [
    "-DWITH_CUDA=ON"
    "-DWITH_NVML=ON"
    "-DCUDA_LIB=${cuda_cudart}/lib/stubs/libcuda.so"
    "-DCUDA_ARCH=${CUDA_ARCH}"
  ];

  installPhase = ''
    install -Dm644 libxmrig-cuda.so $out/lib/libxmrig-cuda.so
  '';
}
