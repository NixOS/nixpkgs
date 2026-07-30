{
  fetchFromGitHub,
  lib,
  ocl-icd,
  opencl-headers,
  stdenv,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prpll";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "preda";
    repo = "gpuowl";
    tag = "v/prpll/${finalAttrs.version}";
    hash = "sha256-uARWaY48IdqWqiX4Z1ZZdhCNGqqVKbyFKOiILSln7ao=";
  };

  enableParallelBuilding = true;

  buildInputs = [
    ocl-icd
    opencl-headers
  ];

  nativeBuildInputs = [ installShellFiles ];

  # Fix stricter compilation rules on aarch64
  postPatch = ''
    substituteInPlace src/common.h \
      --replace-fail "__float128" "_Float128"
  '';

  installPhase = ''
    runHook preInstall

    installBin build-release/prpll

    runHook postInstall
  '';

  meta = {
    description = "Probable Prime and Lucas-Lehmer mersenne categorizer";
    longDescription = ''
      PRPLL implements two primality tests for Mersenne numbers: PRP ("PRobable Prime") and LL ("Lucas-Lehmer") as
      the name suggests.
      PRPLL is an OpenCL (GPU) program for primality testing Mersenne numbers.
    '';
    homepage = "https://github.com/preda/gpuowl";
    maintainers = with lib.maintainers; [ dstremur ];
    license = lib.licenses.gpl3Only;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "prpll";
  };
})
