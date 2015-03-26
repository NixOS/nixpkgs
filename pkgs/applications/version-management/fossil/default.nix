{stdenv, fetchurl, zlib, openssl, tcl, readline, sqlite, withJson ? true}:

stdenv.mkDerivation rec {
  name = "fossil-1.32";

  src = fetchurl {
    urls = 
      [
        "https://www.fossil-scm.org/fossil/tarball/Fossil-6c40678e.tar.gz?uuid=6c40678e9114c41a50f73cc43f6f942ace0408ec"
        ];
    name = "${name}.tar.gz";
    sha256 = "0f1rvqiy630z2q1q8r3kgdd0c6sxjx8c8pm46yabn238xvf3bfnr";
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
