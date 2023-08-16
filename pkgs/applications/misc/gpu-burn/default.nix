{ lib
, fetchFromGitHub
, cudaPackages
}:
let
  inherit (cudaPackages) cuda_nvcc cuda_cudart libcublas;
in

cudaPackages.backendStdenv.mkDerivation rec {
  pname = "gpu-burn";
  version = "unstable-2023-04-13";

  src = fetchFromGitHub {
    owner = "wilicc";
    repo = "gpu-burn";
    rev = "564a9a6d4e953d668bf7584a9c575679d861b1a7";
    hash = "sha256-hZ6XOgB4h840BhX1HYUiNwcv+8lI04SypMqkLjPNcH4=";
  };

  postPatch = ''
    substituteInPlace gpu_burn-drv.cpp \
      --replace '"compare.ptx"' "\"$out/share/compare.ptx\""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  buildInputs = [
    cuda_cudart
    cuda_nvcc
    libcublas
  ];

  makeFlags = [
    "CUDAPATH=/does-not-exist"
    "NVCC=${cuda_nvcc}/bin/nvcc"
  ];

  LDFLAGS = [ "-L${cuda_cudart}/lib/stubs" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp gpu_burn $out/bin/
    cp compare.ptx $out/share/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://wili.cc/blog/gpu-burn.html";
    description = "Multi-GPU CUDA stress test";
    platforms = platforms.linux;
    mainProgram = "gpu_burn";
    maintainers = [ maintainers.elohmeier ] ++ teams.deshaw.members;
    license = licenses.bsd2;
  };
}
