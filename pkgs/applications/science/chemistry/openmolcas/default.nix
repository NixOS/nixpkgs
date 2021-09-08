{ lib, stdenv, fetchFromGitLab, cmake, gfortran, perl
, openblas, hdf5-cpp, python3, texlive
, armadillo, mpi, globalarrays, openssh
, makeWrapper
} :

let
  version = "21.06";
  # The tag keeps moving, fix a hash instead
  gitLabRev = "dd982ad4bc94dec8ac1e3e99cb6a7dd249ff71de";

  python = python3.withPackages (ps : with ps; [ six pyparsing ]);

in stdenv.mkDerivation {
  pname = "openmolcas";
  inherit version;

  src = fetchFromGitLab {
    owner = "Molcas";
    repo = "OpenMolcas";
    rev = gitLabRev;
    sha256 = "07dm73n0s7ckif561yb3s9yqxsv39a73kb9qwny4yp39wdvv52hz";
  };

  patches = [
    # Required to handle openblas multiple outputs
    ./openblasPath.patch
  ];

  nativeBuildInputs = [
    perl
    gfortran
    cmake
    texlive.combined.scheme-minimal
    makeWrapper
  ];

  buildInputs = [
    openblas
    hdf5-cpp
    python
    armadillo
    mpi
    globalarrays
    openssh
  ];

  cmakeFlags = [
    "-DOPENMP=ON"
    "-DGA=ON"
    "-DMPI=ON"
    "-DLINALG=OpenBLAS"
    "-DTOOLS=ON"
    "-DHDF5=ON"
    "-DFDE=ON"
    "-DOPENBLASROOT=${openblas.dev}"
  ];

  GAROOT=globalarrays;

  postConfigure = ''
    # The Makefile will install pymolcas during the build grrr.
    mkdir -p $out/bin
    export PATH=$PATH:$out/bin
  '';

  postInstall = ''
    mv $out/pymolcas $out/bin
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
  };
}

