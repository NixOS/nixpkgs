{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ninja,
  setuptools,
  torch,
  cudaPackages,
  rocmPackages,
  config,
  cudaSupport ? config.cudaSupport,
  which,
}:

buildPythonPackage rec {
  pname = "causal-conv1d";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "causal-conv1d";
    rev = "refs/tags/v${version}";
    hash = "sha256-p5x5u3zEmEMN3mWd88o3jmcpKUnovTvn7I9jIOj/ie0=";
  };

  build-system = [
    ninja
    setuptools
    torch
  ];

  nativeBuildInputs = [ which ];

  buildInputs = (
    lib.optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cudart # cuda_runtime.h, -lcudart
        cuda_cccl
        libcusparse # cusparse.h
        libcusolver # cusolverDn.h
        cuda_nvcc
        libcublas
      ]
    )
  );

  dependencies = [
    torch
  ];

  # pytest tests not enabled due to nvidia GPU dependency
  pythonImportsCheck = [ "causal_conv1d" ];

  env = {
    CAUSAL_CONV1D_FORCE_BUILD = "TRUE";
  } // lib.optionalAttrs cudaSupport { CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}"; };

  meta = with lib; {
    description = "Causal depthwise conv1d in CUDA with a PyTorch interface";
    homepage = "https://github.com/Dao-AILab/causal-conv1d";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cfhammill ];
    # The package requires CUDA or ROCm, the ROCm build hasn't
    # been completed or tested, so broken if not using cuda.
    broken = !cudaSupport;
  };
}
