{
  stdenv,
  lib,
  fetchFromGitHub,
  nixosTests,

  # build
  cmake,
  glib,
  perl,
  pkg-config,

  # runtime
  blas,
  fmt,
  icu,
  jemalloc,
  lapack,
  libarchive,
  libsodium,
  lua,
  luajit,
  openssl,
  pcre2,
  ragel,
  sqlite,
  vectorscan,
  xxhash,
  zstd,

  # flags
  # https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/issues/321
  # Enabling blas support breaks Bayes filter training from within Sieve pipe in Dovecot
  withBlas ? false,
  withLuaJIT ? true,
}:

let
  inherit (lib)
    cmakeFeature
    ;

  # rspamd doesn't consistently accept bools
  cmakeBool' = feature: condition: cmakeFeature feature (if condition then "ON" else "OFF");
in

stdenv.mkDerivation (finalAttrs: {
  pname = "rspamd";
  version = "4.1.5";

  src = fetchFromGitHub {
    owner = "rspamd";
    repo = "rspamd";
    tag = finalAttrs.version;
    hash = "sha256-2Sazb+7dC+d/biypU8PSJJ1v3detQy07wvKaPxwT4Zk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    ragel
  ];

  buildInputs = [
    fmt
    glib
    icu
    jemalloc
    libarchive
    libsodium
    (if withLuaJIT then luajit else lua)
    openssl
    pcre2
    ragel
    sqlite
    vectorscan
    xxhash
    zstd
  ]
  ++ lib.optionals withBlas [
    blas
    lapack
  ];

  cmakeFlags = [
    (cmakeFeature "RUNDIR" "/run/rspamd")
    (cmakeFeature "DBDIR" "/var/lib/rspamd")
    (cmakeFeature "LOGDIR" "/var/log/rspamd")
    (cmakeFeature "LOCAL_CONFDIR" "/etc/rspamd")
    (cmakeBool' "ENABLE_BLAS" withBlas)
    (cmakeBool' "ENABLE_HYPERSCAN" true)
    (cmakeBool' "ENABLE_JEMALLOC" true)
    (cmakeBool' "ENABLE_LUAJIT" withLuaJIT)
    (cmakeBool' "ENABLE_PCRE2" true)
    # doctest 2.5.0 compat problems https://github.com/rspamd/rspamd/issues/5994
    (cmakeBool' "SYSTEM_DOCTEST" false)
    (cmakeBool' "SYSTEM_XXHASH" true)
    (cmakeBool' "SYSTEM_ZSTD" true)
  ];

  __structuredAttrs = true;

  passthru.tests = nixosTests.rspamd;

  meta = {
    changelog = "https://github.com/rspamd/rspamd/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://rspamd.com";
    license = lib.licenses.asl20;
    description = "Advanced spam filtering system";
    maintainers = with lib.maintainers; [
      avnik
      fpletz
      lewo
    ];
    mainProgram = "rspamd";
    platforms = with lib.platforms; linux;
  };
})
