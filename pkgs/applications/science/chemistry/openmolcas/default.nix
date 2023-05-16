<<<<<<< HEAD
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
, texlive
, armadillo
, libxc
, makeWrapper
, gsl
, boost175
, autoPatchelfHook
  # Note that the CASPT2 module is broken with MPI
  # See https://gitlab.com/Molcas/OpenMolcas/-/issues/169
, enableMpi ? false
, mpi
, globalarrays
}:
=======
{ lib, stdenv, fetchFromGitLab, cmake, gfortran, perl
, blas-ilp64, hdf5-cpp, python3, texlive
, armadillo, libxc, makeWrapper
# Note that the CASPT2 module is broken with MPI
# See https://gitlab.com/Molcas/OpenMolcas/-/issues/169
, enableMpi ? false
, mpi, globalarrays
} :
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

assert blas-ilp64.isILP64;
assert lib.elem blas-ilp64.passthru.implementation [ "openblas" "mkl" ];

let
<<<<<<< HEAD
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
stdenv.mkDerivation {
  pname = "openmolcas";
  version = "23.06";
=======
  python = python3.withPackages (ps : with ps; [ six pyparsing numpy h5py ]);

in stdenv.mkDerivation {
  pname = "openmolcas";
  version = "23.02";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "Molcas";
    repo = "OpenMolcas";
    # The tag keeps moving, fix a hash instead
<<<<<<< HEAD
    rev = "1cda3772686cbf99a4af695929a12d563c795ca2"; # 2023-06-12
    sha256 = "sha256-DLRQsRy2jt8V8q2sKmv2hLuKCuMihp/+zcMY/3sg1Fk=";
=======
    rev = "03265f62cd98b985712b063aea88313f984a8857"; # 2023-02-11
    sha256 = "sha256-Kj2RDJq8PEvKclLrSYIOdl6g6lcRsTNZCjwxGOs3joY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # Required to handle openblas multiple outputs
    ./openblasPath.patch
<<<<<<< HEAD

    # Required for a local QCMaquis build
    ./qcmaquis.patch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postPatch = ''
    # Using env fails in the sandbox
    substituteInPlace Tools/pymolcas/export.py --replace \
      "/usr/bin/env','python3" "python3"
<<<<<<< HEAD

    # Pointing CMake to local QCMaquis and NEVPT2 archives
    substituteInPlace cmake/custom/qcmaquis.cmake \
      --subst-var-by "qcmaquis_src_url" "file://${qcmaquisSrc}"

    substituteInPlace cmake/custom/nevpt2.cmake \
      --subst-var-by "nevpt2_src_url" "file://${nevtp2Src}"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  nativeBuildInputs = [
    perl
    gfortran
    cmake
    texlive.combined.scheme-minimal
    makeWrapper
<<<<<<< HEAD
    autoPatchelfHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    blas-ilp64.passthru.provider
    hdf5-cpp
    python
    armadillo
    libxc
<<<<<<< HEAD
    gsl.dev
    boost175
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    "-DEXTERNAL_LIBXC=${libxc}"
<<<<<<< HEAD
    "-DDMRG=ON"
    "-DNEVPT2=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ] ++ lib.optionals (blas-ilp64.passthru.implementation == "openblas") [
    "-DOPENBLASROOT=${blas-ilp64.passthru.provider.dev}"
    "-DLINALG=OpenBLAS"
  ] ++ lib.optionals (blas-ilp64.passthru.implementation == "mkl") [
    "-DMKLROOT=${blas-ilp64.passthru.provider}"
    "-DLINALG=MKL"
=======
  ] ++ lib.optionals (blas-ilp64.passthru.implementation == "openblas") [
    "-DOPENBLASROOT=${blas-ilp64.passthru.provider.dev}" "-DLINALG=OpenBLAS"
  ] ++ lib.optionals (blas-ilp64.passthru.implementation == "mkl") [
    "-DMKLROOT=${blas-ilp64.passthru.provider}" "-DLINALG=MKL"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  # DMRG executables contain references to /build, however, they are properly
  # removed by autopatchelf
  noAuditTmpdir = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    license = with licenses; [ lgpl21Only bsd3 ];
=======
    license = licenses.lgpl21Only;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [ "x86_64-linux" ];
    mainProgram = "pymolcas";
  };
}

