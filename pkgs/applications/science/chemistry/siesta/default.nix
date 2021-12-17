{ lib, stdenv
, gfortran, blas, lapack, scalapack
, useMpi ? false
, mpi
, fetchFromGitLab
}:

stdenv.mkDerivation rec {
  version = "4.1.5";
  pname = "siesta";

  src = fetchFromGitLab {
    owner = "siesta-project";
    repo = "siesta";
    rev = "v${version}";
    sha256 = "0lz8rfl5xwdj17zn7a30ipi7cgjwqki21a7wg9rdg7iwx27bpnmg";
  };

  passthru = {
    inherit mpi;
  };

  nativeBuildInputs = [ gfortran ];

  buildInputs = [ blas lapack ]
    ++ lib.optionals useMpi [ mpi scalapack ];

  enableParallelBuilding = true;

  # Must do manualy becuase siesta does not do the regular
  # ./configure; make; make install
  configurePhase = ''
    cd Obj
    sh ../Src/obj_setup.sh
    cp gfortran.make arch.make
  '';

  preBuild = if useMpi then ''
    makeFlagsArray=(
        CC="mpicc" FC="mpifort"
        FPPFLAGS="-DMPI" MPI_INTERFACE="libmpi_f90.a" MPI_INCLUDE="."
        COMP_LIBS="" LIBS="-lblas -llapack -lscalapack"
    );
  '' else ''
    makeFlagsArray=(
      COMP_LIBS="" LIBS="-lblas -llapack"
    );
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a siesta $out/bin
  '';

  meta = with lib; {
    description = "A first-principles materials simulation code using DFT";
    longDescription = ''
         SIESTA is both a method and its computer program
         implementation, to perform efficient electronic structure
         calculations and ab initio molecular dynamics simulations of
         molecules and solids. SIESTA's efficiency stems from the use
         of strictly localized basis sets and from the implementation
         of linear-scaling algorithms which can be applied to suitable
         systems. A very important feature of the code is that its
         accuracy and cost can be tuned in a wide range, from quick
         exploratory calculations to highly accurate simulations
         matching the quality of other approaches, such as plane-wave
         and all-electron methods.
      '';
    homepage = "https://siesta-project.org/siesta/";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.costrouc ];
  };
}
