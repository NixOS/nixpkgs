{ stdenv, fetchurl, perl , taktuk}:

stdenv.mkDerivation rec {
  version = "1.2.2";
  name = "kanif-${version}";

  propagateBuildInputs = [ perl taktuk ];

  src = fetchurl {
    url = "http://gforge.inria.fr/frs/download.php/26773/${name}.tar.gz";
    sha256 = "3f0c549428dfe88457c1db293cfac2a22b203f872904c3abf372651ac12e5879";
  };

  preBuild = ''
      substituteInPlace ./kanif --replace "/usr/bin/perl" "${perl}/bin/perl"
      substituteInPlace ./kanif --replace '$taktuk_command = "taktuk";' '$taktuk_command = "${taktuk}/bin/taktuk";'
  '';

  meta = {
    description = "Cluster management and administration swiss army knife";
    longDescription = ''
      Kanif is a tool for high performance computing clusters management and
      administration. It combines the main functionalities of well-known cluster
      management tools such as c3, pdsh and dsh, and mimics their syntax. It
      provides three tools to run the same command on several nodes ("parallel
      ssh", using the 'kash' command), to broadcast the copy of files or
      directories to several nodes ('kaput' command), and to gather several
      remote files or directories locally ('kaget' command). It relies on TakTuk
      for efficiency and scalability.'';
    homepage = http://taktuk.gforge.inria.fr/kanif;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    platforms = stdenv.lib.platforms.linux;
  };

}

