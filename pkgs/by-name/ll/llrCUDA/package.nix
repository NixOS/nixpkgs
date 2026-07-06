{
  fetchzip,
  lib,
  gmp,
  cudaPackages,
  autoPatchelfHook,
}:
let
  inherit (cudaPackages) backendStdenv;
in
backendStdenv.mkDerivation (finalAttrs: {
  pname = "llrCUDA";
  version = "4.0.0";

  src = fetchzip {
    url = "http://jpenne.free.fr/llr4/llrcuda${
      builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }srcgpu12.zip";
    hash = "sha256-/v89jsTKCpkmCMKp9nUf7VAnSobE8pDdwLw5n3Hz9dw=";
  };

  enableParallelBuilding = true;

  # Disable _chdir in lprime.cu to prevent segmentation fault when fopen returns NULL
  postPatch = ''
    substituteInPlace lprime.cu \
      --replace-fail "_chdir (buf)" "0/* _chdir (buf) */"

    substituteInPlace Makefile \
      --replace-fail "/usr/local/cuda" "${cudaPackages.cuda_nvcc}"
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    gmp
    cudaPackages.cuda_cudart
    cudaPackages.libcufft
    cudaPackages.cuda_cccl
  ];

  env = {
    NIX_LDFLAGS = lib.concatStringsSep " " [
      "-L${lib.getLib gmp}/lib"
      "-L${lib.getLib cudaPackages.cuda_cudart}/lib"
    ];
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 dllrCUDA $out/bin/llrCUDA

    runHook postInstall
  '';

  meta = {
    description = "GPU version of the LLR program";
    longDescription = ''
      Primality proving program for numbers of the form N = k*b^n +/- 1, (k < b^n),
      or numbers which can be rewritten in this form, like
      Gaussian-Mersenne norms or b^n-b^m +/- 1 with n>m (new feature).
      The identity Phi(3,-X) = X^2-X+1 is now used with X=b^n to search for
      Generalized Unique Primes.
    '';
    homepage = "http://jpenne.free.fr/index2.html";
    maintainers = with lib.maintainers; [ dstremur ];
    license = lib.licenses.unfree;
    # Restricted by GWNUM terms and CUDA dependencies.
    # Its CUDA code is based on GWNUM.
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "llrCUDA";
  };
})
