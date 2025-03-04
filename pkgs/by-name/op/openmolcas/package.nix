{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchFromGitHub,
  cmake,
  gfortran,
  perl,
  blas-ilp64,
  hdf5-cpp,
  python3,
  texliveMinimal,
  armadillo,
  libxc,
  makeWrapper,
  gsl,
  boost,
  autoPatchelfHook,
  enableQcmaquis ? false,
  # Note that the CASPT2 module is broken with MPI
  # See https://gitlab.com/Molcas/OpenMolcas/-/issues/169
  enableMpi ? false,
  mpi,
  globalarrays,
}:

assert blas-ilp64.isILP64;
assert lib.elem blas-ilp64.passthru.implementation [
  "openblas"
  "mkl"
];
assert enableQcmaquis -> lib.elem blas-ilp64.passthru.implementation "mkl";

let
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
    rev = "release-3.1.4"; # Must match tag in cmake/custom/qcmaquis.cmake
    hash = "sha256-vhC5k+91IPFxdCi5oYt1NtF9W08RxonJjPpA0ls4I+o=";
  };
  nevtp2Src = fetchFromGitHub {
    owner = "qcscine";
    repo = "nevpt2";
    rev = "e1484fd"; # Must match tag in cmake/custom/nevpt2.cmake
    hash = "sha256-Vl+FhwhJBbD/7U2CwsYE9BClSQYLJ8DKXV9EXxQUmz0=";
  };

in
stdenv.mkDerivation rec {
  pname = "openmolcas";
  version = "24.10";

  src = fetchFromGitLab {
    owner = "Molcas";
    repo = "OpenMolcas";
    rev = "v${version}";
    hash = "sha256-LXxr/xqBHG7a0rOBrb8IMZ4IjZak3NsBw40Qf+z1fic=";
  };

  patches = [
    # Required to handle openblas multiple outputs
    ./openblasPath.patch

    # Required for a local QCMaquis build
    ./qcmaquis.patch
  ];

  postPatch = ''
    # Using env fails in the sandbox
    substituteInPlace Tools/pymolcas/export.py --replace \
      "/usr/bin/env','python3" "python3"

    # Pointing CMake to local QCMaquis and NEVPT2 archives
    substituteInPlace cmake/custom/qcmaquis.cmake \
      --subst-var-by "qcmaquis_src_url" "file://${qcmaquisSrc}"

    substituteInPlace cmake/custom/nevpt2.cmake \
      --subst-var-by "nevpt2_src_url" "file://${nevtp2Src}"
  '';

  nativeBuildInputs = [
    perl
    gfortran
    cmake
    texliveMinimal
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs =
    [
      blas-ilp64.passthru.provider
      hdf5-cpp
      python
      armadillo
      libxc
      gsl.dev
      boost
    ]
    ++ lib.optionals enableMpi [
      mpi
      globalarrays
    ];

  passthru = lib.optionalAttrs enableMpi { inherit mpi; };

  cmakeFlags =
    [
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
    ]
    ++ lib.optionals (blas-ilp64.passthru.implementation == "openblas") [
      "-DOPENBLASROOT=${blas-ilp64.passthru.provider.dev}"
      "-DLINALG=OpenBLAS"
    ]
    ++ lib.optionals (blas-ilp64.passthru.implementation == "mkl") [
      "-DMKLROOT=${blas-ilp64.passthru.provider}"
      "-DLINALG=MKL"
    ]
    ++ lib.optionals enableMpi [
      "-DGA=ON"
      "-DMPI=ON"
    ];

  preConfigure = lib.optionalString enableMpi ''
    export GAROOT=${globalarrays};
  '';

  postConfigure = ''
    # The Makefile will install pymolcas during the build grrr.
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

  postFixup = ''
    # Wrong store path in shebang (bare Python, no Python pkgs), force manual re-patching
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
}
