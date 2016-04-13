{ stdenv 
, fetchurl 
, pkgconfig 
, ncurses 
, mpi ? null
}:

stdenv.mkDerivation rec {
  name = "neuron-7.4";
  buildInputs = [ stdenv pkgconfig ncurses mpi ];

  src = fetchurl {
    url = "http://www.neuron.yale.edu/ftp/neuron/versions/v7.4/nrn-7.4.tar.gz";
    sha256 = "1rid8cmv5mca0vqkgwahm0prkwkbdvchgw2bdwvx4adkn8bbl0ql";
  };


  enableParallelBuilding = true;

  configureFlags = [ "--without-x"
		     "${if mpi != null then "--with-mpi" else "--without-mpi"}" ];

  meta = with stdenv.lib; {
    description = "Simulation environment for empirically-based simulations of neurons and networks of neurons";

    longDescription = "NEURON is a simulation environment for developing and exercising models of 
		neurons and networks of neurons. It is particularly well-suited to problems where 
		cable properties of cells play an important role, possibly including extracellular 
		potential close to the membrane), and where cell membrane properties are complex, 
		involving many ion-specific channels, ion accumulation, and second messengers";

    license     = licenses.bsd3;
    homepage    = http://www.neuron.yale.edu/neuron;
    maintainers = [ maintainers.adev ];
    platforms   = platforms.all;
  };  
}

