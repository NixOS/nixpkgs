{
  lib,
  stdenv,
  cudatoolkit,
  autoAddDriverRunpath,
  cudaPackages,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mfaktc";
  version = "0.23.5";

  src = fetchFromGitHub {
    owner = "primesearch";
    repo = "mfaktc";
    tag = "${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-NUcRd+WvmRjXC7rfOKFw4mue7V9oobsy/OTHHEoaiHo=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [
    cudatoolkit
    cudaPackages.cuda_cudart
    autoAddDriverRunpath
  ];

  sourceRoot = "${finalAttrs.src.name}/src";

  preBuild = ''
    chmod +w ..
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ../mfaktc -t $out/bin

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
      Attention: You need to supply your own mfaktc.ini, which needs to be in the running directory.
    '';
    homepage = "https://github.com/primesearch/mfaktc";
    downloadPage = "https://github.com/primesearch/mfaktc/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ dstremur ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    badPlatforms = [
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "mfaktc";
  };
})
