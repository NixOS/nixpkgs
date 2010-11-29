{stdenv, fetchurl, zlib, openssl, tcl}:

let
  version = "20101117133825";
in

stdenv.mkDerivation {
  name = "fossil-${version}";

  src = fetchurl {
    url = "http://www.fossil-scm.org/download/fossil-src-${version}.tar.gz";
    sha256 = "0h4g7qsbz5vyd3zxywcc2pf6vf3gavxqznpx8gn47j8y6mjp4byn";
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
