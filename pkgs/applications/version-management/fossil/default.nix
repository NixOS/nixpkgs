{
  lib,
  stdenv,
  installShellFiles,
  tcl,
  libiconv,
  fetchurl,
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
  version = "2.27";

  src = fetchurl {
    url = "https://www.fossil-scm.org/home/tarball/version-${finalAttrs.version}/fossil-${finalAttrs.version}.tar.gz";
    hash = "sha256-1YVOgyNBDy/CeuVfrhE/D4LfQwv5uFfykoYwiZ3eFFY=";
  };

  # required for build time tool `./tools/translate.c`
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    installShellFiles
    tcl
  ];

  buildInputs = [
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
    lib.optional (!withInternalSqlite) "--disable-internal-sqlite" ++ lib.optional withJson "--json";

  preBuild = ''
    export USER=nonexistent-but-specified-user
  '';

  # see https://fossil-scm.org/home/vinfo/4619d2efab946460?diff=1
  preCheck = ''
    mv test/settings.test test/settings.test.off
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
