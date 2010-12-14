{stdenv, fetchurl, zlib, openssl, tcl}:

let
  version = "20101207133137";
in

stdenv.mkDerivation {
  name = "fossil-${version}";

  src = fetchurl {
    url = "http://www.fossil-scm.org/download/fossil-src-${version}.tar.gz";
    sha256 = "1yx35gq9ialvnvjn1r5yar4zxgy0rkxzyz9paxwy8qan3qb53mwz";
  };

  buildInputs = [ zlib openssl tcl ];
  buildNativeInputs = [ zlib openssl ];

  doCheck = true;

  checkTarget = "test";

  crossAttrs = {
    doCheck = false;
  };

  installPhase = ''
    ensureDir $out/bin
    INSTALLDIR=$out/bin make install
  '';

  meta = {
    description = "Simple, high-reliability, distributed software configuration management.";
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
