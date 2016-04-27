{stdenv, libiconv, fetchurl, zlib, openssl, tcl, readline, sqlite, withJson ? true}:

stdenv.mkDerivation rec {
  name = "fossil-1.33";

  src = fetchurl {
    urls = 
      [
        https://www.fossil-scm.org/download/fossil-src-1.33.tar.gz
      ];
    name = "${name}.tar.gz";
    sha256 = "0gkzd9nj3xyznh9x8whv0phdnj11l5c8164rc3l0jvs5i61c95b2";
  };

  buildInputs = [ zlib openssl readline sqlite ]
             ++ stdenv.lib.optional stdenv.isDarwin libiconv;
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
