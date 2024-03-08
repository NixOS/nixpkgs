{ lib
, stdenv
, fetchFromGitLab
, fetchFromGitHub
, cmake
, gfortran
, perl
, blas-ilp64
, hdf5-cpp
, python3
, texliveMinimal
, armadillo
, libxc
, makeWrapper
, gsl
, boost180
, autoPatchelfHook
  # Note that the CASPT2 module is broken with MPI
  # See https://gitlab.com/Molcas/OpenMolcas/-/issues/169
, enableMpi ? false
, mpi
, globalarrays
}:

assert blas-ilp64.isILP64;
assert lib.elem blas-ilp64.passthru.implementation [ "openblas" "mkl" ];

let
  python = python3.withPackages (ps: with ps; [ six pyparsing numpy h5py ]);
  qcmaquisSrc = fetchFromGitHub {
    owner = "qcscine";
    repo = "qcmaquis";
    rev = "release-3.1.1"; # Must match tag in cmake/custom/qcmaquis.cmake
    hash = "sha256-diLDWj/Om6EHrVp+Hd24jsN6R9vV2vRl0y9gqyRWhkI=";
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
  version = "24.02";

  src = fetchFromGitLab {
    owner = "Molcas";
    repo = "OpenMolcas";
    rev = "v${version}";
    hash = "sha256-4Ek0cnaRfLEbj1Nj31rRp9b2sois4rIFTcpOUq9h2mw=";
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

  buildInputs = [
    blas-ilp64.passthru.provider
    hdf5-cpp
    python
    armadillo
    libxc
    gsl.dev
    boost180
  ] ++ lib.optionals enableMpi [
    mpi
    globalarrays
  ];

  passthru = lib.optionalAttrs enableMpi { inherit mpi; };

  cmakeFlags = [
    "-DOPENMP=ON"
    "-DLINALG=OpenBLAS"
    "-DTOOLS=ON"
    "-DHDF5=ON"
    "-DFDE=ON"
    "-DEXTERNAL_LIBXC=${lib.getDev libxc}"
    "-DDMRG=ON"
    "-DNEVPT2=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ] ++ lib.optionals (blas-ilp64.passthru.implementation == "openblas") [
    "-DOPENBLASROOT=${blas-ilp64.passthru.provider.dev}"
    "-DLINALG=OpenBLAS"
  ] ++ lib.optionals (blas-ilp64.passthru.implementation == "mkl") [
    "-DMKLROOT=${blas-ilp64.passthru.provider}"
    "-DLINALG=MKL"
  ] ++ lib.optionals enableMpi [
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
    # Wrong store path in shebang (no Python pkgs), force re-patching
    sed -i "1s:/.*:/usr/bin/env python:" $out/bin/pymolcas
    patchShebangs $out/bin

    wrapProgram $out/bin/pymolcas --set MOLCAS $out
  '';

  meta = with lib; {
    description = "Advanced quantum chemistry software package";
    homepage = "https://gitlab.com/Molcas/OpenMolcas";
    maintainers = [ maintainers.markuskowa ];
    license = with licenses; [ lgpl21Only bsd3 ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
    mainProgram = "pymolcas";
  };
}

