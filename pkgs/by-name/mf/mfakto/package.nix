{
  fetchFromGitHub,
  lib,
  ocl-icd,
  opencl-headers,
  stdenv,
  makeBinaryWrapper,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mfakto";
  version = "0.16.0-beta.5";

  src = fetchFromGitHub {
    owner = "primesearch";
    repo = "mfakto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aQWFvdCWrab8Bz4lRWtdp2pS2Rswi5MS/1Ka5n/iJTU=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildInputs = [
    ocl-icd
    opencl-headers
  ];

  # Patch the hardcoded kernel path
  # Inject opencl-headers for GPU compilation
  postPatch = ''
    substituteInPlace src/mfakto.h \
        --replace-fail '"mfakto_Kernels.cl"' '"'$out'/share/mfakto/mfakto_Kernels.cl"'
    sed -i "/clBuildProgram/i \    strcat(program_options, \" -I $out/share/mfakto\");" src/mfakto.cpp
  '';

  makeFlags = [
    "-C"
    "src"
    # Override needed for aarch64 support
    "CC=${stdenv.cc.targetPrefix}gcc"
    "CPP=${stdenv.cc.targetPrefix}g++"
    "LD=${stdenv.cc.targetPrefix}g++"
    "SHELL=${runtimeShell}"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 mfakto $out/bin/mfakto
    install -Dm644 mfakto.ini -t $out/share/mfakto

    install -Dm444 *.cl $out/share/mfakto
    install -Dm444 *.h $out/share/mfakto

    runHook postInstall
  '';

  meta = {
    description = "Trial Factoring program using OpenCL for GIMPS";
    longDescription = ''
      mfakto is an OpenCL port of mfaktc that aims to have the same features and
      functions. mfaktc is a program that trial factors Mersenne numbers. It stands
      for "Mersenne faktorisation* with CUDA" and was written for Nvidia GPUs. Both
      programs are used primarily in the Great Internet Mersenne Prime Search. mfakto
      can also run on CPUs, although this is not done in practice.
    '';
    homepage = "https://github.com/primesearch/mfakto";
    maintainers = with lib.maintainers; [ dstremur ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "mfakto";
  };
})
