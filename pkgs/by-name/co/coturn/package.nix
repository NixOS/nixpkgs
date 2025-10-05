{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  libevent,
  pkg-config,
  libprom,
  libmicrohttpd,
  sqlite,
  nixosTests,
  systemdMinimal,
}:

stdenv.mkDerivation rec {
  pname = "coturn";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    tag = version;
    hash = "sha256-nvImelAvcbHpv6JTxX+sKpldVXG6u9Biu+VDt95r9I4=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    (libevent.override { inherit openssl; })
    libprom
    libmicrohttpd
    sqlite.dev
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform systemdMinimal) [
    systemdMinimal
  ];

  patches = [
    ./pure-configure.patch

    # Don't call setgroups unconditionally in mainrelay
    # https://github.com/coturn/coturn/pull/1508
    ./dont-call-setgroups-unconditionally.patch
  ];

  configureFlags = [
    # don't install examples due to broken symlinks
    "--examplesdir=.."
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: ...-libprom-0.1.1/include/prom_collector_registry.h:37: multiple definition of
  #     `PROM_COLLECTOR_REGISTRY_DEFAULT'; ...-libprom-0.1.1/include/prom_collector_registry.h:37: first defined here
  # Should be fixed in libprom-1.2.0 and later: https://github.com/digitalocean/prometheus-client-c/pull/25
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  passthru.tests.coturn = nixosTests.coturn;

  meta = {
    description = "TURN server";
    homepage = "https://coturn.net/";
    changelog = "https://github.com/coturn/coturn/blob/${version}/ChangeLog";
    license = with lib.licenses; [ bsd3 ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    broken = stdenv.hostPlatform.isDarwin; # 2018-10-21
  };
}
