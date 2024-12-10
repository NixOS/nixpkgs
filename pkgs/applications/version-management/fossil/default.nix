{
  lib,
  stdenv,
  installShellFiles,
  tcl,
  libiconv,
  fetchurl,
  fetchpatch,
  buildPackages,
  zlib,
  openssl,
  readline,
  withInternalSqlite ? true,
  sqlite,
  ed,
  which,
  tclPackages,
  withJson ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fossil";
  version = "2.24";

  src = fetchurl {
    url = "https://www.fossil-scm.org/home/tarball/version-${finalAttrs.version}/fossil-${finalAttrs.version}.tar.gz";
    hash = "sha256-lc08F2g1vrm4lwdvpYFx/jCwspH2OHu1R0nvvfqWL0w=";
  };

  # required for build time tool `./tools/translate.c`
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    installShellFiles
    tcl
    tclPackages.tcllib
  ];

  buildInputs =
    [
      zlib
      openssl
      readline
      which
      ed
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin libiconv
    ++ lib.optional (!withInternalSqlite) sqlite;

  enableParallelBuilding = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  configureFlags =
    lib.optional (!withInternalSqlite) "--disable-internal-sqlite"
    ++ lib.optional withJson "--json";

  patches = [
    (fetchpatch {
      url = "https://fossil-scm.org/home/vpatch?from=8be0372c10510437&to=5ad708085a90365f";
      extraPrefix = "";
      hash = "sha256-KxF40wiEY3R1RFM0/YOmdNiedQHzs+vyMXslnqLtqQ4=";
      name = "fossil-disable-tests.patch";
    })
    (fetchpatch {
      url = "https://fossil-scm.org/home/vpatch?from=fb4e90b662803e47&to=17c01c549e73c6b8";
      extraPrefix = "";
      hash = "sha256-b0JSDWEBTlLWFr5rO+g0biPzUfVsdeAw71DR7/WQKzU=";
      name = "fossil-fix-json-test.patch";
    })
    (fetchpatch {
      url = "https://fossil-scm.org/home/vpatch?from=5ad708085a90365f&to=fb4e90b662803e47";
      extraPrefix = "";
      hash = "sha256-bbWUrlhPxC/DQQDeC3gG0jGfxQ6F7YkxINqg3baf+j0=";
      name = "fossil-comment-utf-tests.patch";
    })
  ];

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
    maintainers = with maintainers; [ maggesi ];
    platforms = platforms.all;
    mainProgram = "fossil";
  };
})
