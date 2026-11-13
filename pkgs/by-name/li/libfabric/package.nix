{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  enablePsm2 ? (stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isLinux),
  libpsm2,
  enableOpx ? (stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isLinux && !cudaSupport),
  libuuid,
  numactl,
  rdma-core,
  enableEfa ? stdenv.hostPlatform.isLinux,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfabric";
  version = "2.7.0";

  enableParallelBuilding = true;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ofiwg";
    repo = "libfabric";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YDqCgRW+ZJSyf6+9aZebVEA5SAQHMwxofwuYkfGhT4M=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs =
    lib.optionals enableOpx [
      libuuid
      numactl
    ]
    ++ lib.optionals enablePsm2 [ libpsm2 ]
    ++ lib.optionals enableEfa [ rdma-core ]
    ++ lib.optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cudart
        cuda_nvml_dev
      ]
    );

  configureFlags = [
    (lib.enableFeatureAs enablePsm2 "psm2" libpsm2)
    (lib.enableFeature enableOpx "opx")
    (lib.enableFeature enableEfa "efa")
    (lib.enableFeature cudaSupport "cuda-dlopen")
    (lib.withFeatureAs cudaSupport "cuda" (lib.getDev cudaPackages.cuda_cudart))
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://ofiwg.github.io/libfabric/";
    description = "Open Fabric Interfaces";
    license = with lib.licenses; [
      gpl2
      bsd2
    ];
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bzizou ];
    mainProgram = "fi_info";
  };
})
