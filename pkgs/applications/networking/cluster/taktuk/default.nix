{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  version = "3.7.7";
  pname = "taktuk";

  buildInputs = [ perl ];

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/33412/${pname}-${version}.tar.gz";
    sha256 = "0w0h3ynlcxvq2nzm8hkj20g0805ww3vkw53g0qwj7wvp7p3gcvnr";
  };

  preBuild = ''
      substituteInPlace ./taktuk --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  meta = {
    description = "Efficient, large scale, parallel remote execution of commands";
    mainProgram = "taktuk";
    longDescription = ''
      TakTuk allows one to execute commands in parallel on a potentially large set
      of remote nodes (using ssh to connect to each node). It is typically used
      inside high performance computing clusters and grids. It uses an adaptive
      algorithm to efficiently distribute the work and sets up an interconnection
      network to transport commands and perform I/Os multiplexing. It doesn't
      require any specific software on the nodes thanks to a self-propagation
      algorithm.'';
    homepage = "http://taktuk.gforge.inria.fr/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.linux;
  };
}

