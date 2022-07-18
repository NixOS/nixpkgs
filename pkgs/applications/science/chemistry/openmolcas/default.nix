{ lib, stdenv, fetchFromGitLab, cmake, gfortran, perl
, blas-ilp64, hdf5-cpp, python3, texlive
, armadillo, libxc, makeWrapper
# Note that the CASPT2 module is broken with MPI
# See https://gitlab.com/Molcas/OpenMolcas/-/issues/169
, enableMpi ? false
, mpi, globalarrays
} :

assert blas-ilp64.isILP64;
assert lib.elem blas-ilp64.passthru.implementation [ "openblas" "mkl" ];

let
  python = python3.withPackages (ps : with ps; [ six pyparsing numpy h5py ]);

in stdenv.mkDerivation {
  pname = "openmolcas";
  version = "22.06";

  src = fetchFromGitLab {
    owner = "Molcas";
    repo = "OpenMolcas";
    # The tag keeps moving, fix a hash instead
    rev = "17238da5c339c41ddf14ceb88f139d57143d7a14"; # 2022-06-17
    sha256 = "0g17x5fp27b57f7j284xl3b3i9c4b909q504wpz0ipb0mrcvcpdp";
  };

  patches = [
    # Required to handle openblas multiple outputs
    ./openblasPath.patch
    # Required for MKL builds
    ./MKL-MPICH.patch
  ];

  postPatch = ''
    # Using env fails in the sandbox
    substituteInPlace Tools/pymolcas/export.py --replace \
      "/usr/bin/env','python3" "python3"
  '';

  nativeBuildInputs = [
    perl
    gfortran
    cmake
    texlive.combined.scheme-minimal
    makeWrapper
  ];

  buildInputs = [
    blas-ilp64.passthru.provider
    hdf5-cpp
    python
    armadillo
    libxc
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
  ] ++ lib.optionals (blas-ilp64.passthru.implementation == "openblas") [
    "-DOPENBLASROOT=${blas-ilp64.passthru.provider.dev}" "-DLINALG=OpenBLAS"
  ] ++ lib.optionals (blas-ilp64.passthru.implementation == "mkl") [
    "-DMKLROOT=${blas-ilp64.passthru.provider}" "-DLINALG=MKL"
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
    license = licenses.lgpl21Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "pymolcas";
  };
}

