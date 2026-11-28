{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  config,
  enableCuda ? config.cudaSupport,
  cudaPackages,
  versionCheckHook,
  installShellFiles,
  unstableGitUpdater,
  autoAddDriverRunpath,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "peakperf";
  version = "1.17-unstable-2026-04-05";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Dr-Noob";
    repo = "peakperf";
    rev = "ebb5c632bd10ca6e5971a19e6975b94eea418838";
    hash = "sha256-ILClzqjjQmk0Quk27XYMH5Dq6hQg+YHNscQwwxF2JI4=";
  };

  nativeBuildInputs = [
    cmake
    installShellFiles
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ];

  buildInputs = lib.optionals enableCuda [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvml_dev
  ];

  postInstall = ''
    installManPage ${finalAttrs.src}/peakperf.1
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = [
    "-v"
  ];

  preVersionCheck = ''
    export version=1.18
  '';

  doInstallCheck = true;

  versionCheckProgram = "${placeholder "out"}/bin/peakperf";

  meta = {
    homepage = "https://github.com/Dr-Noob/peakperf";
    description = "Achieve peak performance on x86 CPUs and NVIDIA GPUs";
    mainProgram = "peakperf";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.gpl2Only;
  };
})
