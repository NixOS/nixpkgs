{stdenv, fetchurl, zlib, openssl, tcl, readline, sqlite}:

let
  version = "1.20";
  filedate = "20111021125253";
in

stdenv.mkDerivation {
  name = "fossil-${version}";

  src = fetchurl {
    url = "http://www.fossil-scm.org/download/fossil-src-${filedate}.tar.gz";
    sha256 = "0m75kw77iray3kbjm1xfn8hr116fn11yv1wr7adcwy314cgj0vv3";
  };

  buildInputs = [ zlib openssl readline sqlite ];
  buildNativeInputs = [ tcl ];

  doCheck = true;

  checkTarget = "test";

  installPhase = ''
    ensureDir $out/bin
    INSTALLDIR=$out/bin make install
  '';

  crossAttrs = {
    doCheck = false;
    makeFlagsArray = [ "TCC=${stdenv.cross.config}-gcc" ];
  };

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
