{
  lib,
  fetchFromGitHub,
  cmake,
  cudaPackages,
  boost,
  autoAddDriverRunpath,
}:

cudaPackages.backendStdenv.mkDerivation rec {
  pname = "nvbandwidth";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvbandwidth";
    rev = "v${version}";
    hash = "sha256-PhJY7F0aGNoejLlhSNT3p3PjYKfywCq2nZGvHTu0Q/8=";

  };

  nativeBuildInputs = [
    cmake
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ];

  buildInputs = [
    boost
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvml_dev
  ];

  env.LDFLAGS = toString [
    # Fake libcuda.so (the real one is deployed impurely)
    "-L${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs"
    # Fake libnvidia-ml.so (the real one is deployed impurely)
    "-L${lib.getOutput "stubs" cudaPackages.cuda_nvml_dev}/lib/stubs"
  ];

  postPatch = ''
    # Handle missing /etc/os-release
    substituteInPlace CMakeLists.txt \
      --replace-fail 'file(READ "/etc/os-release" OS_RELEASE_CONTENT)' \
                     'if(EXISTS "/etc/os-release")
        file(READ "/etc/os-release" OS_RELEASE_CONTENT)
    else()
        set(OS_RELEASE_CONTENT "")
    endif()'

    # Force shared Boost libraries
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(Boost_USE_STATIC_LIBS ON)' \
                     'set(Boost_USE_STATIC_LIBS OFF)'
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp nvbandwidth $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "A tool for bandwidth measurements on NVIDIA GPUs";
    homepage = "https://github.com/NVIDIA/nvbandwidth";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ths-on ];
    platforms = lib.platforms.linux;
    mainProgram = "nvbandwidth";
  };
}
