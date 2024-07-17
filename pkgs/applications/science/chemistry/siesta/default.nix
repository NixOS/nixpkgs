{
  lib,
  stdenv,
  gfortran,
  blas,
  lapack,
  scalapack,
  useMpi ? false,
  mpi,
  fetchFromGitLab,
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

  postPatch = ''
    substituteInPlace Src/siesta_init.F --replace '/bin/rm' 'rm'
  '';

  passthru = {
    inherit mpi;
  };

  nativeBuildInputs = [ gfortran ];

  buildInputs =
    [
      blas
      lapack
    ]
    ++ lib.optionals useMpi [
      mpi
      scalapack
    ];

  enableParallelBuilding = false; # Started making trouble with gcc-11

  # Must do manually because siesta does not do the regular
  # ./configure; make; make install
  configurePhase = ''
    cd Obj
    sh ../Src/obj_setup.sh
    cp gfortran.make arch.make
  '';

  preBuild =
    ''
      # See https://gitlab.com/siesta-project/siesta/-/commit/a10bf1628e7141ba263841889c3503c263de1582
      # This may be fixed in the next release.
      makeFlagsArray=(
          FFLAGS="-fallow-argument-mismatch"
      )
    ''
    + (
      if useMpi then
        ''
          makeFlagsArray+=(
              CC="mpicc" FC="mpifort"
              FPPFLAGS="-DMPI" MPI_INTERFACE="libmpi_f90.a" MPI_INCLUDE="."
              COMP_LIBS="" LIBS="-lblas -llapack -lscalapack"
          );
        ''
      else
        ''
          makeFlagsArray+=(
            COMP_LIBS="" LIBS="-lblas -llapack"
          );
        ''
    );

  installPhase = ''
    mkdir -p $out/bin
    cp -a siesta $out/bin
  '';

  meta = with lib; {
    description = "A first-principles materials simulation code using DFT";
    mainProgram = "siesta";
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
