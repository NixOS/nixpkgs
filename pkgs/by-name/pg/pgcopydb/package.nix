{ lib
, stdenv
, fetchFromGitHub
, libkrb5
, openssl
, pam
, pkg-config
, postgresql
, readline
, sqlite
, testers
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgcopydb";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "dimitri";
    repo = "pgcopydb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m9iIF8h6V3wWLUQuPntXtRAh16RrmR3uqZZIljGCY08=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libkrb5
    openssl
    postgresql
    readline
    sqlite
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    pam
  ];

  hardeningDisable = [ "format" ];

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

  meta = with lib; {
    description = "Copy a Postgres database to a target Postgres server (pg_dump | pg_restore on steroids";
    homepage = "https://github.com/dimitri/pgcopydb";
    changelog = "https://github.com/dimitri/pgcopydb/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.postgresql;
    maintainers = with maintainers; [ marsam ];
    mainProgram = "pgcopydb";
    platforms = platforms.all;
  };
})
