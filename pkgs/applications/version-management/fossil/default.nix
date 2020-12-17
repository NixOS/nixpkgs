{ stdenv
, installShellFiles
, tcl
, libiconv
, fetchurl
, zlib
, openssl
, readline
, sqlite
, ed
, which
, tcllib
, withJson ? true
}:

stdenv.mkDerivation rec {
  pname = "fossil";
  version = "2.13";

  src = fetchurl {
    urls =
      [
        "https://www.fossil-scm.org/index.html/uv/fossil-src-${version}.tar.gz"
      ];
    name = "${pname}-${version}.tar.gz";
    sha256 = "1xbk7bb7340x2vvn22ykii54v721fwk8vgr3xvjkvv8ff7hd6cyr";
  };

  nativeBuildInputs = [ installShellFiles tcl ];

  buildInputs = [ zlib openssl readline sqlite which ed ]
    ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  configureFlags = [ "--disable-internal-sqlite" ]
    ++ stdenv.lib.optional withJson "--json";

  preCheck = ''
    export TCLLIBPATH="${tcllib}/lib/tcllib${tcllib.version}"
  '';

  preBuild = ''
    export USER=nonexistent-but-specified-user
  '';

  installPhase = ''
    mkdir -p $out/bin
    INSTALLDIR=$out/bin make install

    installManPage fossil.1
    installShellCompletion --name fossil.bash tools/fossil-autocomplete.bash
  '';

  meta = with stdenv.lib; {
    description = "Simple, high-reliability, distributed software configuration management";
    longDescription = ''
      Fossil is a software configuration management system.  Fossil is
      software that is designed to control and track the development of a
      software project and to record the history of the project. There are
      many such systems in use today. Fossil strives to distinguish itself
      from the others by being extremely simple to setup and operate.
    '';
    homepage = "http://www.fossil-scm.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ maggesi viric ];
  };
}
