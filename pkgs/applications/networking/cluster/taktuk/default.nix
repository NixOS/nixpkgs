{ stdenv, fetchurl, perl , openssh}:

stdenv.mkDerivation rec {
  version = "3.7.5";
  name = "taktuk-${version}";

  buildInputs = [ perl ];

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/33412/${name}.tar.gz";
    sha256 = "d96ef6c63d77f32339066f143ef7e0bc00041e10724254bf15787746ad1f1070";
  };

  preBuild = ''
      substituteInPlace ./taktuk --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  meta = {
    description = "Efficient, large scale, parallel remote execution of commands";
    longDescription = ''
      TakTuk allows one to execute commands in parallel on a potentially large set
      of remote nodes (using ssh to connect to each node). It is typically used
      inside high performance computing clusters and grids. It uses an adaptive
      algorithm to efficiently distribute the work and sets up an interconnection
      network to transport commands and perform I/Os multiplexing. It doesn't
      require any specific software on the nodes thanks to a self-propagation
      algorithm.'';
    homepage = http://taktuk.gforge.inria.fr/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    platforms = stdenv.lib.platforms.linux;
  };
}

