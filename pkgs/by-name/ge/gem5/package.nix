{
  boost,
  capstone,
  fetchFromGitHub,
  gperftools,
  hdf5-cpp,
  isa ? "X86", # ARM, NULL, MIPS, POWER, RISCV, SPARC, or X86
  lib,
  libpng,
  m4,
  protobuf_21,
  python3,
  scons,
  stdenv,
  variant ? "opt", # debug, opt, or fast
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gem5-${isa}-${variant}";
  version = "24.1.0.3";

  src = fetchFromGitHub {
    owner = "gem5";
    repo = "gem5";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MLceCx4Sv+LHDXdmc4wuIArDZjelh7dDqmnPGNVJ2zo=";
  };

  nativeBuildInputs = [
    m4
    python3
    scons
  ];

  buildInputs = [
    boost
    capstone
    gperftools # provides tcmalloc
    hdf5-cpp
    libpng
    protobuf_21
    zlib
  ];

  buildFlags = [ "build/${isa}/gem5.${variant}" ];

  enableParallelBuilding = true;

  preBuild = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp build/${isa}/gem5.${variant} $out/bin/

    runHook postInstall
  '';

  meta = {
    description = "A modular platform for computer-system architecture research";
    homepage = "https://www.gem5.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "gem5.${variant}";
  };
})
