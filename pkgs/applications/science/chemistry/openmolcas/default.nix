{ stdenv, pkgs, fetchFromGitLab, cmake, gfortran, perl
, openblas, hdf5-cpp, python3, texlive
, armadillo, openmpi, globalarrays, openssh
, makeWrapper
} :

let
  version = "20180529";
  gitLabRev = "b6b9ceffccae0dd7f14c099468334fee0b1071fc";

  python = python3.withPackages (ps : with ps; [ six pyparsing ]);

in stdenv.mkDerivation {
  name = "openmolcas-${version}";

  src = fetchFromGitLab {
    owner = "Molcas";
    repo = "OpenMolcas";
    rev = gitLabRev;
    sha256 = "1wbjjdv07lg1x4kdnf28anyrjgy33gdgrd5d7zi1c97nz7vhdjaz";
  };

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

