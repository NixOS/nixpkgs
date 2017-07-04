{stdenv, libiconv, fetchurl, zlib, openssl, tcl, readline, sqlite, ed, which
, tcllib, withJson ? true}:

stdenv.mkDerivation rec {
  name = "fossil-1.36";

  src = fetchurl {
    urls = 
      [
        https://fossil-scm.org/index.html/uv/download/fossil-src-1.36.tar.gz
      ];
    name = "${name}.tar.gz";
    sha256 = "04px1mnq5dlc6gaihxj5nj6k7ac43wfryzifaairjh74qmgc6xi6";
  };

  buildInputs = [ zlib openssl readline sqlite which ed ]
             ++ stdenv.lib.optional stdenv.isDarwin libiconv;
  nativeBuildInputs = [ tcl ];

  doCheck = true;

  checkTarget = "test";

  preCheck = ''
    export TCLLIBPATH="${tcllib}/lib/tcllib${tcllib.version}"
  '';
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
    makeFlags = [ "TCC=$CC" ];
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
