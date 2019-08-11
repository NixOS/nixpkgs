{ stdenv, fetchurl
, gfortran, openblas
, mpi ? null, scalapack
}:

stdenv.mkDerivation rec {
  version = "4.1-b3";
  name = "siesta-${version}";

  src = fetchurl {
    url = "https://launchpad.net/siesta/4.1/4.1-b3/+download/siesta-4.1-b3.tar.gz";
    sha256 = "1450jsxj5aifa0b5fcg7mxxq242fvqnp4zxpgzgbkdp99vrp06gm";
  };

  passthru = {
    inherit mpi;
  };

  buildInputs = [ openblas gfortran ]
    ++ (stdenv.lib.optionals (mpi != null) [ mpi scalapack ]);

  enableParallelBuilding = true;

  # Must do manualy becuase siesta does not do the regular
  # ./configure; make; make install
  configurePhase = ''
    cd Obj
    sh ../Src/obj_setup.sh
    cp gfortran.make arch.make
  '';

  preBuild = if (mpi != null) then ''
    makeFlagsArray=(
        CC="mpicc" FC="mpifort"
        FPPFLAGS="-DMPI" MPI_INTERFACE="libmpi_f90.a" MPI_INCLUDE="."
        COMP_LIBS="" LIBS="-lopenblas -lscalapack"
    );
  '' else ''
    makeFlagsArray=(
      COMP_LIBS="" LIBS="-lopenblas"
    );
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a siesta $out/bin
  '';

  meta = with stdenv.lib; {
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
    homepage = https://www.quantum-espresso.org/;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.costrouc ];
  };
}
