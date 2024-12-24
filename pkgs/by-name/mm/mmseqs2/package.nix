{
  lib,
  config,
  stdenv,
  fetchFromGitHub,
  cmake,
  xxd,
  perl,
  installShellFiles,
  enableAvx2 ? stdenv.hostPlatform.avx2Support,
  enableSse4_1 ? stdenv.hostPlatform.sse4_1Support,
  enableMpi ? false,
  mpi,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  llvmPackages,
  zlib,
  bzip2,
  pkgsStatic,
  runCommand,
}:
let
  # require static library, libzstd.a
  inherit (pkgsStatic) zstd;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "mmseqs2";
  version = "16-747c6";

  src = fetchFromGitHub {
    owner = "soedinglab";
    repo = "mmseqs2";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-O7tx+gdVAmZLihPnWSo9RWNVzfPjI61LGY/XeaGHrI0=";
  };

  nativeBuildInputs =
    [
      cmake
      xxd
      perl
      installShellFiles
      zstd
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
    ];

  cmakeFlags =
    [
      (lib.cmakeBool "HAVE_AVX2" enableAvx2)
      (lib.cmakeBool "HAVE_SSE4_1" enableSse4_1)
      (lib.cmakeBool "HAVE_MPI" enableMpi)
      (lib.cmakeBool "USE_SYSTEM_ZSTD" true)
      (lib.cmakeBool "HAVE_ARM8" stdenv.hostPlatform.isAarch64)
    ]
    ++ lib.optionals cudaSupport [
      (lib.cmakeBool "ENABLE_CUDA" true)
      (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
    ];

  buildInputs =
    lib.optionals stdenv.cc.isClang [
      llvmPackages.openmp
      zlib
      bzip2
    ]
    ++ lib.optional enableMpi mpi
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_cudart
      cudaPackages.cuda_cccl
    ];

  postInstall = ''
    installShellCompletion --bash --cmd mmseqs $out/util/bash-completion.sh
    rm -r $out/util/
  '';

  passthru.tests = {
    example = runCommand "mmseqs2-test" { } ''
      ${lib.getExe finalAttrs.finalPackage} createdb ${finalAttrs.src}/examples/DB.fasta targetDB > $out
      ${lib.getExe finalAttrs.finalPackage} createindex targetDB tmp >> $out
      ${lib.getExe finalAttrs.finalPackage} easy-search ${finalAttrs.src}/examples/QUERY.fasta targetDB alnRes.m8 tmp >> $out
    '';
  };

  meta = with lib; {
    description = "Ultra fast and sensitive sequence search and clustering suite";
    mainProgram = "mmseqs";
    homepage = "https://mmseqs.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
