{ stdenv
, libiconv, fetchurl, zlib, openssl, tcl, readline, sqlite, ed, which
, tcllib, withJson ? true
}:

stdenv.mkDerivation rec {
  pname = "fossil";
  version = "2.9";

  src = fetchurl {
    urls =
      [
        "https://www.fossil-scm.org/index.html/uv/fossil-src-${version}.tar.gz"
      ];
    name = "${pname}-${version}.tar.gz";
    sha256 = "0kwb7pkp7y2my916rhyl6kmcf0fk8gkzaxzy13hfgqs35nlsvchw";
  };

  buildInputs = [ zlib openssl readline sqlite which ed ]
             ++ stdenv.lib.optional stdenv.isDarwin libiconv;
  nativeBuildInputs = [ tcl ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  preCheck = ''
    export TCLLIBPATH="${tcllib}/lib/tcllib${tcllib.version}"
  '';
  configureFlags = stdenv.lib.optional withJson "--json";

  preBuild=''
    export USER=nonexistent-but-specified-user
  '';

  installPhase = ''
    mkdir -p $out/bin
    INSTALLDIR=$out/bin make install
  '';

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
