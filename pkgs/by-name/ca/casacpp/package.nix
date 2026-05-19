{
  lib,
  stdenv,
  fetchgit,
  cmake,
  common-updater-scripts,
  curl,
  gnugrep,
  writeShellScript,
  pkg-config,
  flex,
  bison,
  gfortran,
  casacore,
  libsakura,
  grpc,
  protobuf,
  gsl,
  libxml2,
  libxslt,
  fftw,
  fftwFloat,
  sqlite,
  openssl,
  mpi,
  mpiSupport ? false,
}:
let
  casacppPackages = {
    fftw = fftw.override {
      inherit mpi;
      enableMpi = mpiSupport;
    };
    fftwFloat = fftwFloat.override {
      inherit mpi;
      enableMpi = mpiSupport;
    };
    casacore = casacore.override {
      inherit mpi mpiSupport;
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "casacpp";
  version = "6.7.5.18";

  src = fetchgit {
    url = "https://open-bitbucket.nrao.edu/scm/casa/casa6.git";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-75oIlaNAyu70KWSjz38LoYAvV7RJgzH/X9uBnGpriF4=";
    fetchSubmodules = false;
  };

  sourceRoot = "${finalAttrs.src.name}/casatools/src/code";

  patches = [
    # Fix the generated .pc file: set Requires from a variable instead of
    # leaving it empty, and remove hardcoded absolute cmake build paths from
    # Cflags (which would embed /nix/store paths from the build environment).
    ./casacpp-pkgconfig.patch
  ];

  postPatch = ''
    sed -i '/execute_process(COMMAND/,/OUTPUT_VARIABLE CASACPP_VERSION)/c\set(CASACPP_VERSION "${finalAttrs.version}")' CMakeLists.txt
    sed -i 's/string(REGEX MATCH.*CASACPP_VERSION)//' CMakeLists.txt
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'find_package(gRPC QUIET)' \
        'set(gRPC_FOUND 0)'
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    flex
    bison
    gfortran
    grpc # for grpc_cpp_plugin
  ]
  ++ lib.optional mpiSupport mpi;

  buildInputs = [
    libxslt
    sqlite
    openssl
  ];

  propagatedBuildInputs = [
    casacppPackages.casacore
    protobuf
    grpc
    casacppPackages.fftw
    casacppPackages.fftwFloat
    libsakura
    gsl
    libxml2
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-ffp-contract=off")
  ];

  enableParallelBuilding = true;

  passthru.updateScript = writeShellScript "update-casacpp" ''
    version=$(${lib.getExe curl} -s https://pypi.org/pypi/casatasks/json | ${lib.getExe gnugrep} -oP '"version"\s*:\s*"\K[^"]+' | head -1)
    ${lib.getExe' common-updater-scripts "update-source-version"} casacpp "$version"
  '';

  meta = {
    description = "C++ core libraries for radio interferometry data reduction";
    homepage = "https://casa.nrao.edu/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kiranshila ];
  };
})
