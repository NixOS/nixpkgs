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
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgbouncer";
  version = "1.26.1";

  src = fetchurl {
    url = "https://www.pgbouncer.org/downloads/files/${finalAttrs.version}/pgbouncer-${finalAttrs.version}.tar.gz";
    hash = "sha256-AIhqKZS0hEzTcRCXDfd3dyz8QqdMQAUiyC+6UJo/Qtk=";
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
  ++ lib.optional systemdSupport systemd;
  enableParallelBuilding = true;
  configureFlags = lib.optional systemdSupport "--with-systemd";

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
