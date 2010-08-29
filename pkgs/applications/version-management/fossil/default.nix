{stdenv, fetchurl, zlib, openssl}:

let
  version = "20100823222416";
in

stdenv.mkDerivation {
  name = "fossil-${version}";

  src = fetchurl {
    url = "http://www.fossil-scm.org/download/fossil-src-${version}.tar.gz";
    sha256 = "16wxg27pyzrv7p5qmaf0gkxpydjxplck5s933aqcwp6xkpx0ys8v";
  };

  buildInputs = [ zlib openssl ];

  installPhase = ''
    ensureDir $out/bin
    INSTALLDIR=$out/bin make install
  '';

  crossAttrs = {
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
    license = "GPLv2";
    maintainers = [ #Add your name here!
      stdenv.lib.maintainers.z77z
    ];
  };
}
