{ stdenv, fetchFromGitLab, cmake, gfortran, perl
, openblas, hdf5-cpp, python3, texlive
, armadillo, openmpi, globalarrays, openssh
, makeWrapper, fetchpatch
} :

let
  version = "19.11";
  gitLabRev = "v${version}";

  python = python3.withPackages (ps : with ps; [ six pyparsing ]);

in stdenv.mkDerivation {
  pname = "openmolcas";
  inherit version;

  src = fetchFromGitLab {
    owner = "Molcas";
    repo = "OpenMolcas";
    rev = gitLabRev;
    sha256 = "1wwqhkyyi7pw5x1ghnp83ir17zl5jsj7phhqxapybyi3bmg0i00q";
  };

  patches = [ (fetchpatch {
    name = "Fix-MPI-INT-size"; # upstream patch, fixes a Fortran compiler error
    url = "https://gitlab.com/Molcas/OpenMolcas/commit/860e3350523f05ab18e49a428febac8a4297b6e4.patch";
    sha256 = "0h96h5ikbi5l6ky41nkxmxfhjiykkiifq7vc2s3fdy1r1siv09sb";
  }) (fetchpatch {
    name = "fix-cisandbox"; # upstream patch, fixes a Fortran compiler error
    url = "https://gitlab.com/Molcas/OpenMolcas/commit/d871590c8ce4689cd94cdbbc618954c65589393d.patch";
    sha256 = "0dgz1w2rkglnis76spai3m51qa72j4bz6ppnk5zmzrr6ql7gwpgg";
  })];

  nativeBuildInputs = [ perl cmake texlive.combined.scheme-minimal makeWrapper ];
  buildInputs = [
    gfortran
    openblas
    hdf5-cpp
    python
    armadillo
    openmpi
    globalarrays
    openssh
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DOPENMP=ON"
    "-DGA=ON"
    "-DMPI=ON"
    "-DLINALG=OpenBLAS"
    "-DTOOLS=ON"
    "-DHDF5=ON"
    "-DFDE=ON"
    "-DOPENBLASROOT=${openblas}"
  ];

  GAROOT=globalarrays;

  postConfigure = ''
    # The Makefile will install pymolcas during the build grrr.
    mkdir -p $out/bin
    export PATH=$PATH:$out/bin
  '';

  postFixup = ''
    # Wrong store path in shebang (no Python pkgs), force re-patching
    sed -i "1s:/.*:/usr/bin/env python:" $out/bin/pymolcas
    patchShebangs $out/bin

    wrapProgram $out/bin/pymolcas --set MOLCAS $out
  '';

  meta = with stdenv.lib; {
    description = "Advanced quantum chemistry software package";
    homepage = https://gitlab.com/Molcas/OpenMolcas;
    maintainers = [ maintainers.markuskowa ];
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}

