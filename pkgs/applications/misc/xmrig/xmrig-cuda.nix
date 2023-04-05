{ stdenv
, autoAddOpenGLRunpathHook
, fetchFromGitHub
, cmake
, pkgs
, tree
, cudaArch ? 61
}:

let
  libcudaDir = "/run/opengl-driver/lib";
in
stdenv.mkDerivation rec {
  inherit (pkgs.cudaPackages) cudatoolkit cuda_cudart;

  version = "6.17.0";
  pname = "xmrig-cuda";
  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig-cuda";
    rev = "v${version}";
    sha256 = "sha256-vRVLmMgCG42btm0jcteZiftchjRZotBgT98znQV0I+k=";
  };

  nativeBuildInputs = [ cmake autoAddOpenGLRunpathHook ];

  buildInputs = [
    cudatoolkit
    cuda_cudart
  ];

  cmakeFlags = [
    "-DCUDA_TOOLKIT_ROOT_DIR=${cudatoolkit}"
    "-DLIBCUDA_LIBRARY_DIR=${libcudaDir}"
    "-DCUDA_LIB=${libcudaDir}/libcuda.so"
    "-DCUDA_CUDA_LIBRARY=${libcudaDir}/libcuda.so"
    "-DCUDA_CUDART_LIBRARY=${cuda_cudart}/lib/libcudart.so"
    "-DLIBNVRTC_LIBRARY_DIR=${cudatoolkit}/lib"
    "-DCUDA_NVRTC_LIB=${cudatoolkit}/lib/libnvrtc.so" # or from cuda_nvrtc?
    "-DCUDA_ARCH=${builtins.toString cudaArch}"
  ];

  installPhase = ''
    install -Dm644 libxmrig-cuda.so $out/lib/libxmrig-cuda.so
  '';
}
