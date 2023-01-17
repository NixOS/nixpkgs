{ lib, stdenv
, installShellFiles
, tcl
, libiconv
, fetchurl
, buildPackages
, zlib
, openssl
, readline
, withInternalSqlite ? true
, sqlite
, ed
, which
, tcllib
, withJson ? true
}:

stdenv.mkDerivation rec {
  pname = "fossil";
  version = "2.20";

  src = fetchurl {
    url = "https://www.fossil-scm.org/home/tarball/version-${version}/fossil-${version}.tar.gz";
    sha256 = "1knff50rr8f39myxj50fprb9ya87cslmwz7zzfya56l33r7i7jh3";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ installShellFiles tcl tcllib ];

  buildInputs = [ zlib openssl readline which ed ]
    ++ lib.optional stdenv.isDarwin libiconv
    ++ lib.optional (!withInternalSqlite) sqlite;

  enableParallelBuilding = true;

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  configureFlags =
    lib.optional (!withInternalSqlite) "--disable-internal-sqlite"
    ++ lib.optional withJson "--json";

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
