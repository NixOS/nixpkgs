{
  boost,
  capstone,
  fetchFromGitHub,
  gperftools,
  hdf5-cpp,
  isa ? "X86",
  lib,
  libpng,
  m4,
  protobuf_21,
  python3,
  scons,
  stdenv,
  variant ? "opt",
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gem5-${isa}-${variant}";
  version = "24.1.0.1";

  src = fetchFromGitHub {
    owner = "gem5";
    repo = "gem5";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q7+LuCGUINvsuF7GyiEC7/veADTVi1FpkUXajl2TDkA=";
  };

  # Needed to make the current release compile, see:
  # https://github.com/gem5/gem5/pull/1897 (the PR was rejected, but there is no
  # release with the fix).
  patches = [ ./include-algorithm.patch ];

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
    maintainers = [ lib.maintainers.mtoohey ];
  };
})
