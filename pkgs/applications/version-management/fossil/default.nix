{stdenv, fetchurl, zlib, openssl, tcl, readline, sqlite, withJson ? true}:

stdenv.mkDerivation {
  name = "fossil-1.27";

  src = fetchurl {
    url = http://www.fossil-scm.org/download/fossil-src-20130911114349.tar.gz;
    sha256 = "0n40z8bx2311i11zjx2x15lw3q8vzjwvfqzikrjlqnpal4vzd72f";
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
    license = "BSD";
    platforms = with stdenv.lib.platforms; all;
    maintainers = [ #Add your name here!
      stdenv.lib.maintainers.z77z
      stdenv.lib.maintainers.viric
    ];
  };
}
