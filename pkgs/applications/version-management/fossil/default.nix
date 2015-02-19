{stdenv, fetchurl, zlib, openssl, tcl, readline, sqlite, withJson ? true}:

stdenv.mkDerivation {
  name = "fossil-1.30";

  src = fetchurl {
    url = http://www.fossil-scm.org/download/fossil-src-20150119112900.tar.gz;
    sha256 = "1p4jxd67m2a5rl85hb9gl0vxcvvkxnj1hd8yjaci2qf115d9x5ip";
  };

  buildInputs = [ zlib openssl readline sqlite ];
  nativeBuildInputs = [ tcl ];

  doCheck = true;

  checkTarget = "test";
  configureFlags = if withJson then  "--json" else  "";

  preBuild=''
    export USER=nonexistent-but-specified-user
  '';

  installPhase = ''
    mkdir -p $out/bin
    INSTALLDIR=$out/bin make install
  '';

  crossAttrs = {
    doCheck = false;
    makeFlagsArray = [ "TCC=${stdenv.cross.config}-gcc" ];
  };

  meta = {
    description = "Simple, high-reliability, distributed software configuration management";
    longDescription = ''
      Fossil is a software configuration management system.  Fossil is
      software that is designed to control and track the development of a
      software project and to record the history of the project. There are
      many such systems in use today. Fossil strives to distinguish itself
      from the others by being extremely simple to setup and operate.
    '';
    homepage = http://www.fossil-scm.org/;
    license = stdenv.lib.licenses.bsd2;
    platforms = with stdenv.lib.platforms; all;
    maintainers = [ #Add your name here!
      stdenv.lib.maintainers.z77z
      stdenv.lib.maintainers.viric
    ];
  };
}
