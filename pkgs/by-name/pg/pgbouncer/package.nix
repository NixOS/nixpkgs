{
  lib,
  stdenv,
  fetchurl,
  openssl,
  libevent,
  c-ares,
  pkg-config,
<<<<<<< HEAD
  python3,
  pandoc,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  systemd,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "pgbouncer";
<<<<<<< HEAD
  version = "1.25.1";

  src = fetchurl {
    url = "https://www.pgbouncer.org/downloads/files/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-blZq6S/j739qG54m1gSffXyjnEDinns49tVQCuFdhGU=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
    pandoc
  ];
=======
  version = "1.24.1";

  src = fetchurl {
    url = "https://www.pgbouncer.org/downloads/files/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-2nKjq6EwcodtBVo+WN1Kukpd5O1hSOcwMxhSRVmP0+A=";
  };

  nativeBuildInputs = [ pkg-config ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://www.pgbouncer.org/";
    mainProgram = "pgbouncer";
    description = "Lightweight connection pooler for PostgreSQL";
    changelog = "https://github.com/pgbouncer/pgbouncer/releases/tag/pgbouncer_${
<<<<<<< HEAD
      lib.replaceStrings [ "." ] [ "_" ] version
    }";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ _1000101 ];
    platforms = lib.platforms.all;
=======
      replaceStrings [ "." ] [ "_" ] version
    }";
    license = licenses.isc;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
