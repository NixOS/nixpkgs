{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchFromGitHub,
  cmake,
  gfortran,
  perl,
  blas-ilp64,
  lapack-ilp64,
  hdf5-cpp,
  python3,
  texliveMinimal,
  armadillo,
  libxc,
  makeWrapper,
  gsl,
  boost188,
  libwignernj,
  autoPatchelfHook,
  enableQcmaquis ? true,
  # Note that the CASPT2 module is broken with MPI
  # See https://gitlab.com/Molcas/OpenMolcas/-/issues/169
  enableMpi ? false,
  mpi,
  globalarrays-ilp64,
}:

assert blas-ilp64.isILP64;
assert lapack-ilp64.isILP64;
assert enableMpi -> globalarrays-ilp64.isILP64;

let
  boost = boost188;
  python = python3.withPackages (
    ps: with ps; [
      six
      pyparsing
      numpy
      h5py
    ]
  );
  qcmaquisSrc = fetchFromGitHub {
    owner = "qcscine";
    repo = "qcmaquis";
    rev = "9ff551fecbdbad43d17600c441a9c9bfb9811d3e"; # Current head of "nag-compiler-fix-internal" as pinned in OpenMolcas' Cmake
    hash = "sha256-+EtfgYg6apREDOltXu8zfUbpuiV56k4RvuPAYO0fbsM=";
  };

  # NEVPT2 sources must be patched to be valid C code in gctime.c
  nevpt2Src = stdenv.mkDerivation {
    pname = "nevpt2-src";
    version = "unstable";
    src = fetchFromGitHub {
      owner = "qcscine";
      repo = "nevpt2";
      rev = "65a36d7db403d3b97089106a3ccc15344bf6bc86"; # Must match tag in cmake/custom/nevpt2.cmake
      hash = "sha256-Ah2CjzW80KtRJoFPGYIKcY/vbn4IEWGFdf1TctQ4wD0=";
    };
    patches = [ ./nevpt2.patch ];
    installPhase = ''
      mkdir $out
      cp -r * $out/.
    '';
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "openmolcas";
  version = "26.10";

  src = fetchFromGitLab {
    owner = "Molcas";
    repo = "OpenMolcas";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C67E4IrhVOkky1VsnbXykLKQDjToFpge587B0YJFV2c=";
  };

  patches = [
    # Required for a local QCMaquis build. Also sanitises QCMaquis BLAS/LAPACK handling
    ./qcmaquis.patch
  ];

  postPatch = ''
    # Using env fails in the sandbox
    substituteInPlace Tools/pymolcas/export.py --replace-fail \
      "/usr/bin/env','python3" "python3"

    # Pointing CMake to local QCMaquis and NEVPT2 archives
    substituteInPlace cmake/custom/qcmaquis.cmake \
      --subst-var-by "qcmaquis_src_url" "file://${qcmaquisSrc}"

    substituteInPlace cmake/custom/nevpt2.cmake \
      --subst-var-by "nevpt2_src_url" "file://${nevpt2Src}"
  '';

  nativeBuildInputs = [
    perl
    gfortran
    cmake
    texliveMinimal
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    hdf5-cpp
    python
    armadillo
    libxc
    gsl.dev
    boost
    blas-ilp64
    lapack-ilp64
    libwignernj
  ]
  ++ lib.optionals enableMpi [
    mpi
    globalarrays-ilp64
  ];

  passthru = lib.optionalAttrs enableMpi { inherit mpi; };

  # fix build with GCC 15
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  cmakeFlags = [
    "-DOPENMP=ON"
    "-DTOOLS=ON"
    "-DHDF5=ON"
    "-DFDE=ON"
    "-DEXTERNAL_LIBXC=${lib.getDev libxc}"
    (lib.strings.cmakeBool "DMRG" enableQcmaquis)
    (lib.strings.cmakeBool "NEVPT2" enableQcmaquis)
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    (lib.strings.cmakeBool "BUILD_STATIC_LIBS" stdenv.hostPlatform.isStatic)
    (lib.strings.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    "-DLINALG=Manual"
    (lib.strings.cmakeBool "GA" enableMpi)
    (lib.strings.cmakeBool "MPI" enableMpi)
  ];

  preConfigure = ''
    cmakeFlagsArray+=("-DLINALG_LIBRARIES=-lblas -llapack")
  ''
  + lib.optionalString enableMpi ''
    export GAROOT=${globalarrays-ilp64};
  '';

  # The Makefile will install pymolcas during the build grrr.
  postConfigure = ''
    mkdir -p $out/bin
    export PATH=$PATH:$out/bin
  '';

  postInstall = ''
    mv $out/pymolcas $out/bin
    find $out/Tools -type f -exec mv \{} $out/bin \;
    rm -r $out/Tools
  '';

  # DMRG executables contain references to /build, however, they are properly
  # removed by autopatchelf
  noAuditTmpdir = true;

  enableParallelBuilding = true;

  # Wrong store path in shebang (bare Python, no Python pkgs), force manual re-patching
  postFixup = ''
    for exe in $(find $out/bin/ -type f -name "*.py"); do
      sed -i "1s:.*:#!${python}/bin/python:" "$exe"
    done

    wrapProgram $out/bin/pymolcas --set MOLCAS $out
  '';

  meta = {
    description = "Advanced quantum chemistry software package";
    homepage = "https://gitlab.com/Molcas/OpenMolcas";
    maintainers = [ lib.maintainers.markuskowa ];
    license = with lib.licenses; [
      lgpl21Only
      bsd3
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "pymolcas";
  };
})
