{
  lib,
  fetchFromGitHub,
  llvmPackages_18,
  python3,
  cmake,
  boost,
  libxml2,
  libffi,
  makeWrapper,
  config,
  cudaPackages,
  rocmPackages,
  ompSupport ? true,
  openclSupport ? false,
  rocmSupport ? config.rocmSupport,
  cudaSupport ? config.cudaSupport,
  autoAddDriverRunpath,
  runCommand,
  callPackage,
  symlinkJoin,
  nix-update-script,
}:
let
  inherit (llvmPackages) stdenv;
  llvmPackages = llvmPackages_18;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "adaptivecpp";
  version = "25.02.0";

  src = fetchFromGitHub {
    owner = "AdaptiveCpp";
    repo = "AdaptiveCpp";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-vXfw8+xn3/DYxUKp3QGdQ8sEbDwyk+8jDCyuvQOXigc=";
  };

  # do not use old FindCUDA cmake module
  postPatch = ''
    rm cmake/FindCUDA.cmake
  '';

  # we may be able to get away with just wrapping hipcc and nothing more
  # this is mainly so that if acpp tries doing <PATH_TO_HIPCC>/../amdgcn/bitcode
  rocmMerged = symlinkJoin {
    name = "rocm-merged";
    paths = with rocmPackages; [
      clr
      rocm-core
      rocm-device-libs
      rocm-runtime
    ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/hipcc \
        --add-flags "--rocm-device-lib-path=$out/amdgcn/bitcode"
    '';
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    libxml2
    libffi
    boost
    python3
    llvmPackages.openmp
    llvmPackages.libclang.dev
    llvmPackages.llvm
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
    (lib.getOutput "stubs" cudaPackages.cuda_cudart)
  ];

  # adaptivecpp makes use of clangs internal headers. Its cmake does not successfully discover them automatically on nixos, so we supply the path manually
  cmakeFlags = [
    (lib.cmakeFeature "CLANG_INCLUDE_PATH" "${llvmPackages.libclang.dev}/include")
    (lib.cmakeBool "WITH_CPU_BACKEND" ompSupport)
    (lib.cmakeBool "WITH_CUDA_BACKEND" cudaSupport)
    (lib.cmakeBool "WITH_ROCM_BACKEND" rocmSupport)
    (lib.cmakeBool "WITH_OPENCL_BACKEND" openclSupport)
  ]
  ++ lib.optionals rocmSupport [
    (lib.cmakeFeature "HIPCC_COMPILER" "${finalAttrs.rocmMerged}/bin/hipcc")
    (lib.cmakeFeature "ROCM_PATH" "${finalAttrs.rocmMerged}")
  ];

  # this hardening option breaks rocm builds
  hardeningDisable = [ "zerocallusedregs" ];

  passthru = {
    tests =
      # Loosely based on the AdaptiveCpp GitHub CI: https://github.com/AdaptiveCpp/AdaptiveCpp/blob/develop/.github/workflows/linux.yml
      # This may be overkill, especially as this won't be run on GPU on the CI
      let
        runner = targets: enablePstlTests: callPackage ./tests.nix { inherit enablePstlTests; };
        run =
          runner: cmd: mask:
          runCommand cmd { } ''
            # the test runner wants to write to $HOME/.acpp, so we need to have it point to a real directory
            mkdir home
            export HOME=`pwd`/home

            ACPP_VISIBILITY_MASK="${mask}" ${runner}/bin/${cmd} && touch $out
          '';
        runSycl = runner: mask: run runner "sycl_tests" mask;
        runPstl = runner: mask: run runner "pstl_tests" mask;
        runner-omp = runner "omp" false;
        runner-sscp = runner "generic" true;
      in
      {
        inherit runner-omp runner-sscp;
        sycl-omp = runSycl runner-omp "omp";
        sycl-sscp = runSycl runner-sscp "omp";
        pstl-sscp = runPstl runner-sscp "omp";
      }
      // lib.optionalAttrs rocmSupport (
        let
          runner-rocm = runner "hip:gfx906" false;
          runner-rocm-integrated-multipass = runner "omp;hip:gfx906" false;
          runner-rocm-explicit-multipass = runner "omp;hip.explicit-multipass:gfx906;cuda:sm_61" false;
        in
        {
          inherit runner-rocm runner-rocm-integrated-multipass runner-rocm-explicit-multipass;
          sycl-rocm = runSycl runner-rocm "omp;hip";
          sycl-rocm-imp = runSycl runner-rocm-integrated-multipass "omp;hip";
          sycl-rocm-emp = runSycl runner-rocm-explicit-multipass "omp;hip";
          sycl-rocm-sscp = runSycl runner-sscp "omp;hip";
          pstl-rocm-sscp = runPstl runner-sscp "omp;hip";
        }
      )
      // lib.optionalAttrs cudaSupport (
        let
          runner-cuda = runner "cuda:sm_60" false;
          runner-cuda-integrated-multipass = runner "omp;cuda_61" true;
          runner-cuda-explicit-multipass = runner "omp;cuda.explicit-multipass:sm_61;hip:gfx906" false;
        in
        {
          inherit runner-cuda runner-cuda-integrated-multipass runner-cuda-explicit-multipass;
          sycl-cuda = runSycl runner-cuda "omp;cuda";
          sycl-cuda-imp = runSycl runner-cuda-integrated-multipass "omp;cuda";
          sycl-cuda-emp = runSycl runner-cuda-explicit-multipass "omp;cuda";
          sycl-cuda-sscp = runSycl runner-sscp "omp;cuda";
          pstl-cuda-imp = runPstl runner-cuda-integrated-multipass "omp;cuda";
          pstl-cuda-sscp = runPstl runner-sscp "omp;cuda";
        }
      );

    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/AdaptiveCpp/AdaptiveCpp";
    description = "Multi-backend implementation of SYCL for CPUs and GPUs";
    mainProgram = "acpp";
    maintainers = with lib.maintainers; [ yboettcher ];
    license = lib.licenses.bsd2;
  };
})
