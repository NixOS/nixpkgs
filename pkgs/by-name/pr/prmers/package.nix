{
  curl,
  fetchFromGitHub,
  gmp,
  lib,
  ocl-icd,
  opencl-headers,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prmers";
  version = "4.16.07-alpha";

  src = fetchFromGitHub {
    owner = "cherubrock-seb";
    repo = "PrMers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PbIC2fpTsTFEqxYgG9AWaa2Y2sNbb+bljtR5dE958pY=";
  };

  enableParallelBuilding = true;

  buildInputs = [
    curl
    gmp
    ocl-icd
    opencl-headers
  ];

  installPhase = ''
    runHook preInstall

    make install PREFIX=$out KERNEL_PATH=$out/bin/kernels

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "-v";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=unstable" ]; };

  meta = {
    description = "GPU-accelerated Mersenne primality testing";
    longDescription = ''
      PrMers is a high-performance GPU application for Lucas–Lehmer (LL), PRP, and P-1 testing of Mersenne numbers.
         It uses OpenCL and integer NTT/IBDWT kernels and is built for long, reliable runs with checkpointing and PrimeNet submission.
    '';
    homepage = "https://github.com/cherubrock-seb/PrMers";
    downloadPage = "https://github.com/cherubrock-seb/PrMers/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ dstremur ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "prmers";
  };
})
