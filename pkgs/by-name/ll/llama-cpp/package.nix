{ lib
, cmake
, darwin
, fetchFromGitHub
, fetchpatch
, nix-update-script
, stdenv

, config
, cudaSupport ? config.cudaSupport
, cudaPackages ? { }

, rocmSupport ? config.rocmSupport
, rocmPackages ? { }

, openclSupport ? false
, clblast

, blasSupport ? !rocmSupport && !cudaSupport
, openblas
, pkg-config
, metalSupport ? stdenv.isDarwin && stdenv.isAarch64 && !openclSupport
}:

let
  # It's necessary to consistently use backendStdenv when building with CUDA support,
  # otherwise we get libstdc++ errors downstream.
  # cuda imposes an upper bound on the gcc version, e.g. the latest gcc compatible with cudaPackages_11 is gcc11
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "llama-cpp";
  version = "1710";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "llama.cpp";
    rev = "refs/tags/b${finalAttrs.version}";
    hash = "sha256-fbzHjaL+qAE9HdtBVxboo8T2/KCdS5O1RkTQvDwD/xs=";
  };

  patches = [
    # openblas > v0.3.21 64-bit pkg-config file is now named openblas64.pc
    # can remove when patch is accepted upstream
    # https://github.com/ggerganov/llama.cpp/pull/4134
    (fetchpatch {
      name = "openblas64-pkg-config.patch";
      url = "https://github.com/ggerganov/llama.cpp/commit/c885cc9f76c00557601b877136191b0f7aadc320.patch";
      hash = "sha256-GBTxCiNrCazYRvcHwbqVMAALuJ+Svzf5BE7+nkxw064=";
    })
  ];

  postPatch = ''
    substituteInPlace ./ggml-metal.m \
      --replace '[bundle pathForResource:@"ggml-metal" ofType:@"metal"];' "@\"$out/bin/ggml-metal.metal\";"
  '';

  nativeBuildInputs = [ cmake ] ++ lib.optionals blasSupport [ pkg-config ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc

    # TODO: Replace with autoAddDriverRunpath
    # once https://github.com/NixOS/nixpkgs/pull/275241 has been merged
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  buildInputs = lib.optionals effectiveStdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [
      Accelerate
      CoreGraphics
      CoreVideo
      Foundation
    ])
  ++ lib.optionals metalSupport (with darwin.apple_sdk.frameworks; [
    MetalKit
  ])
  ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_cccl.dev # <nv/target>

    # A temporary hack for reducing the closure size, remove once cudaPackages
    # have stopped using lndir: https://github.com/NixOS/nixpkgs/issues/271792
    cuda_cudart.dev
    cuda_cudart.lib
    cuda_cudart.static
    libcublas.dev
    libcublas.lib
    libcublas.static
  ]) ++ lib.optionals rocmSupport [
    rocmPackages.clr
    rocmPackages.hipblas
    rocmPackages.rocblas
  ] ++ lib.optionals openclSupport [
    clblast
  ] ++ lib.optionals blasSupport [
    openblas
  ];

  cmakeFlags = [
    "-DLLAMA_NATIVE=OFF"
    "-DLLAMA_BUILD_SERVER=ON"
  ]
  ++ lib.optionals metalSupport [
    "-DCMAKE_C_FLAGS=-D__ARM_FEATURE_DOTPROD=1"
    "-DLLAMA_METAL=ON"
  ]
  ++ lib.optionals cudaSupport [
    "-DLLAMA_CUBLAS=ON"
  ]
  ++ lib.optionals rocmSupport [
    "-DLLAMA_HIPBLAS=1"
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
  ]
  ++ lib.optionals openclSupport [
    "-DLLAMA_CLBLAST=ON"
  ]
  ++ lib.optionals blasSupport [
    "-DLLAMA_BLAS=ON"
    "-DLLAMA_BLAS_VENDOR=OpenBLAS"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    for f in bin/*; do
      test -x "$f" || continue
      cp "$f" $out/bin/llama-cpp-"$(basename "$f")"
    done

    ${lib.optionalString metalSupport "cp ./bin/ggml-metal.metal $out/bin/ggml-metal.metal"}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    attrPath = "llama-cpp";
    extraArgs = [ "--version-regex" "b(.*)" ];
  };

  meta = with lib; {
    description = "Port of Facebook's LLaMA model in C/C++";
    homepage = "https://github.com/ggerganov/llama.cpp/";
    license = licenses.mit;
    mainProgram = "llama-cpp-main";
    maintainers = with maintainers; [ dit7ya elohmeier ];
    broken = (effectiveStdenv.isDarwin && effectiveStdenv.isx86_64) || lib.count lib.id [openclSupport blasSupport rocmSupport cudaSupport] == 0;
    platforms = platforms.unix;
  };
})
