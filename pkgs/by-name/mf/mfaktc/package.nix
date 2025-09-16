{
  lib,
  stdenv,
  autoAddDriverRunpath,
  cudaPackages,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mfaktc";
  version = "0.23.6";

  src = fetchFromGitHub {
    owner = "primesearch";
    repo = "mfaktc";
    tag = "${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-+oO2zMGxcnkEUlD1q5Sy79aXp7BtGTTsvbKjPqBt7sw=";
  };

  enableParallelBuilding = true;
  buildInputs = [
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
    autoAddDriverRunpath
  ];

  makeFlags = [
    "-C"
    "src"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 mfaktc -t $out/bin
    install -Dm755 mfaktc.ini -t $out/share

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "-h";

  meta = {
    description = "Trial Factoring program using CUDA for GIMPS";
    longDescription = ''
      CUDA Program for trial factoring Mersenne primes. Intented for use with GIMPS through autoprimenet.py.
      Note that the mfaktc.ini file, which is in $out/share, must be symlinked to your working directory.
    '';
    homepage = "https://github.com/primesearch/mfaktc";
    downloadPage = "https://github.com/primesearch/mfaktc/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ dstremur ];
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "mfaktc";
  };
})
