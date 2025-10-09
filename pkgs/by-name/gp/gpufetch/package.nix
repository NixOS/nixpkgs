{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  config,
  pciutils,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  installShellFiles,
  autoAddDriverRunpath,
  gitUpdater,
  versionCheckHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpufetch";
  version = "0.25";

  src = fetchFromGitHub {
    owner = "Dr-Noob";
    repo = "gpufetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1j23h3TDxa2xu03o37fXfRL3XFYyhMWFGupAlkrYpBY=";
  };

  nativeBuildInputs = [
    cmake
    installShellFiles
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ];

  buildInputs = [
    zlib
    pciutils
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvml_dev
  ];

  installPhase = ''
    runHook preInstall

    installManPage ${finalAttrs.src}/gpufetch.1
    install -Dm755 ./gpufetch $out/bin/gpufetch

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Simple yet fancy GPU architecture fetching tool";
    homepage = "https://github.com/Dr-Noob/gpufetch";
    license = lib.licenses.gpl2Only;
    mainProgram = "gpufetch";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = [ "x86_64-linux" ];
  };
})
