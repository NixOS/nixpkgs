{
  lib,
  clangStdenv,
  fetchFromGitHub,
  boehmgc,
  libkrb5,
  openssl,
  pam,
  pkg-config,
  postgresql,
  readline,
  sqlite,
  testers,
  zlib,
  python3Packages,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "pgcopydb";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "dimitri";
    repo = "pgcopydb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g5MC4F0BYgTimpJZDX+PepFLXv1QuH7XGlzV66xM11M=";
  };

  nativeBuildInputs = [
    pkg-config
    postgresql.pg_config
  ];

  buildInputs = [
    boehmgc
    libkrb5
    openssl
    postgresql
    readline
    sqlite
    zlib
    python3Packages.sphinxHook
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isLinux [
    pam
  ];

  hardeningDisable = [ "format" ];

  sphinxBuilders = [
    "man"
  ];

  installPhase = ''
    runHook preInstall

    install -D -t $out/bin/ src/bin/pgcopydb/pgcopydb

    runHook postInstall
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Copy a Postgres database to a target Postgres server (pg_dump | pg_restore on steroids";
    homepage = "https://github.com/dimitri/pgcopydb";
    changelog = "https://github.com/dimitri/pgcopydb/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.postgresql;
    maintainers = [ ];
    mainProgram = "pgcopydb";
    platforms = lib.platforms.all;
  };
})
