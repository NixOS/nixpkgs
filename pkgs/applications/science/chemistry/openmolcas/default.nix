{ stdenv, fetchFromGitLab, cmake, gfortran, perl
, openblas, blas, lapack, hdf5-cpp, python3, texlive
, armadillo, openmpi, globalarrays, openssh
, makeWrapper, fetchpatch
} :

assert blas.implementation == "openblas" && lapack.implementation == "openblas";

let
  version = "20.10";
  gitLabRev = "v${version}";

  python = python3.withPackages (ps : with ps; [ six pyparsing ]);

in stdenv.mkDerivation {
  pname = "openmolcas";
  inherit version;

  src = fetchFromGitLab {
    owner = "Molcas";
    repo = "OpenMolcas";
    rev = gitLabRev;
    sha256 = "1w8av44dx5r9yp2xhf9ypdrhappvk984wrd5pa1ww0qv6j2446ic";
  };

  patches = [
    # Required to handle openblas multiple outputs
    ./openblasPath.patch
];

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
    "-DOPENBLASROOT=${openblas.dev}"
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
    homepage = "https://gitlab.com/Molcas/OpenMolcas";
    maintainers = [ maintainers.markuskowa ];
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}

