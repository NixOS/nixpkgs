{ lib, stdenv
, installShellFiles
, tcl
, libiconv
, fetchzip
, zlib
, openssl
, readline
, ed
, which
, tcllib
, withJson ? true
}:

stdenv.mkDerivation rec {
  pname = "fossil";
  version = "2.16";

  src = fetchzip {
    url = "https://fossil-scm.org/home/tarball/version-${version}/fossil-${version}.tar.gz";
    sha256 = "0jxnc3zkza3mc40sb6q0f8bfl2wpxhcmdgr5kv56sbryf8xn2dhr";
    name = "${pname}-${version}-src";
  };

  nativeBuildInputs = [ installShellFiles tcl tcllib ];

  buildInputs = [ zlib openssl readline which ed ]
    ++ lib.optional stdenv.isDarwin libiconv;

  enableParallelBuilding = true;

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  configureFlags = lib.optional withJson "--json";

  preBuild = ''
    export USER=nonexistent-but-specified-user
  '';

  installPhase = ''
    mkdir -p $out/bin
    INSTALLDIR=$out/bin make install

    installManPage fossil.1
    installShellCompletion --name fossil.bash tools/fossil-autocomplete.bash
  '';

  meta = with lib; {
    description = "Simple, high-reliability, distributed software configuration management";
    longDescription = ''
      Fossil is a software configuration management system.  Fossil is
      software that is designed to control and track the development of a
      software project and to record the history of the project. There are
      many such systems in use today. Fossil strives to distinguish itself
      from the others by being extremely simple to setup and operate.
    '';
    homepage = "https://www.fossil-scm.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ maggesi viric ];
    platforms = platforms.all;
  };
}
