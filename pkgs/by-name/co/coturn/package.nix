{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  libevent,
  pkg-config,
  libprom,
  libpromhttp,
  libmicrohttpd,
  sqlite,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "coturn";
  version = "4.6.3";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    rev = "refs/tags/${version}";
    hash = "sha256-GG8aQJoCBV5wolPEzSuZhqNn//ytaTAptjY42YKga4E=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    (libevent.override { inherit openssl; })
    libprom
    libpromhttp
    libmicrohttpd
    sqlite.dev
  ];

  patches = [
    ./pure-configure.patch

    # Don't call setgroups unconditionally in mainrelay
    # https://github.com/coturn/coturn/pull/1508
    ./dont-call-setgroups-unconditionally.patch
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: ...-libprom-0.1.1/include/prom_collector_registry.h:37: multiple definition of
  #     `PROM_COLLECTOR_REGISTRY_DEFAULT'; ...-libprom-0.1.1/include/prom_collector_registry.h:37: first defined here
  # Should be fixed in libprom-1.2.0 and later: https://github.com/digitalocean/prometheus-client-c/pull/25
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  passthru.tests.coturn = nixosTests.coturn;

  meta = with lib; {
    description = "TURN server";
    homepage = "https://coturn.net/";
    changelog = "https://github.com/coturn/coturn/blob/${version}/ChangeLog";
    license = with licenses; [ bsd3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ _0x4A6F ];
    broken = stdenv.hostPlatform.isDarwin; # 2018-10-21
  };
}
