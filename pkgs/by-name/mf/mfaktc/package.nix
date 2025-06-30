{
  lib,
  stdenv,
  cudatoolkit,
  autoAddDriverRunpath,
  config,
  cudaPackages,
  fetchFromGitHub,
  gnumake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mfaktc";
  version = "0.23.4";

  src = fetchFromGitHub {
    owner = "primesearch";
    repo = "mfaktc";
    tag = "${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-BlCAKzRFYPv4SYSBhNd+9yXw1PVNGkbqn2lsNeJ526A=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [
    gnumake
    cudatoolkit
    cudaPackages.cuda_cudart
    autoAddDriverRunpath
  ];

  preBuild = ''
    cd src
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -c ../mfaktc $out/bin
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''$out/bin/mfaktc -h > /dev/null '';

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
  };

})
