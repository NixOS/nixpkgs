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
  pcre,
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
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "rspamd";
    repo = "rspamd";
    tag = finalAttrs.version;
    hash = "sha256-8hpplpo57DnOUT1T8jcfGRyIoWySfqrOFrMgH1tept8=";
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
    pcre
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
    # pcre2 jit seems to cause crashes: https://github.com/NixOS/nixpkgs/pull/181908
    (cmakeBool' "ENABLE_PCRE2" false)
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
    platforms = with lib.platforms; linux;
  };
})
