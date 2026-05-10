{
  lib,
  stdenv,
  fetchurl,
  openssl,
  libevent,
  c-ares,
  pkg-config,
  python3,
  pandoc,
  systemd,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgbouncer";
  version = "1.25.1";

  src = fetchurl {
    url = "https://www.pgbouncer.org/downloads/files/${finalAttrs.version}/pgbouncer-${finalAttrs.version}.tar.gz";
    hash = "sha256-blZq6S/j739qG54m1gSffXyjnEDinns49tVQCuFdhGU=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
    pandoc
  ];
  buildInputs = [
    libevent
    openssl
    c-ares
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux systemd;
  enableParallelBuilding = true;
  configureFlags = lib.optional stdenv.hostPlatform.isLinux "--with-systemd";

  passthru.tests = {
    pgbouncer = nixosTests.pgbouncer;
  };

  meta = {
    homepage = "https://www.pgbouncer.org/";
    mainProgram = "pgbouncer";
    description = "Lightweight connection pooler for PostgreSQL";
    changelog = "https://github.com/pgbouncer/pgbouncer/releases/tag/pgbouncer_${
      lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ _1000101 ];
    platforms = lib.platforms.all;
  };
})
