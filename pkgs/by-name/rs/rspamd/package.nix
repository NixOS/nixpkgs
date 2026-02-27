{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  doctest,
  fmt,
  perl,
  glib,
  luajit,
  openssl,
  pcre,
  pkg-config,
  sqlite,
  ragel,
  fasttext,
  icu,
  hyperscan,
  vectorscan,
  jemalloc,
  blas,
  lapack,
  lua,
  libsodium,
  xxHash,
  zstd,
  libarchive,
  # Enabling blas support breaks bayes filter training from dovecot in nixos-mailserver tests
  # https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/issues/321
  withBlas ? false,
  withHyperscan ? false,
  withLuaJIT ? stdenv.hostPlatform.isx86_64,
  withVectorscan ? true,
  nixosTests,
}:

assert withHyperscan -> stdenv.hostPlatform.isx86_64;
assert (!withHyperscan) || (!withVectorscan);

stdenv.mkDerivation (finalAttrs: {
  pname = "rspamd";
  version = "3.14.3";

  src = fetchFromGitHub {
    owner = "rspamd";
    repo = "rspamd";
    tag = finalAttrs.version;
    hash = "sha256-ntWBcwcPZwRRSTUO4a0JUNd6kc49fm+0/x+fqcZIA/o=";
  };

  patches = [
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    ragel
  ];

  buildInputs = [
    doctest
    fmt
    glib
    openssl
    pcre
    sqlite
    ragel
    fasttext
    icu
    jemalloc
    libsodium
    xxHash
    zstd
    libarchive
  ]
  ++ lib.optionals withBlas [
    blas
    lapack
  ]
  ++ lib.optional withHyperscan hyperscan
  ++ lib.optional withLuaJIT luajit
  ++ lib.optional (!withLuaJIT) lua
  ++ lib.optional withVectorscan vectorscan;

  cmakeFlags = [
    # pcre2 jit seems to cause crashes: https://github.com/NixOS/nixpkgs/pull/181908
    "-DENABLE_PCRE2=OFF"
    "-DDEBIAN_BUILD=ON"
    "-DRUNDIR=/run/rspamd"
    "-DDBDIR=/var/lib/rspamd"
    "-DLOGDIR=/var/log/rspamd"
    "-DLOCAL_CONFDIR=/etc/rspamd"
    "-DENABLE_BLAS=${if withBlas then "ON" else "OFF"}"
    "-DENABLE_FASTTEXT=ON"
    "-DENABLE_JEMALLOC=ON"
    "-DSYSTEM_DOCTEST=ON"
    "-DSYSTEM_FMT=ON"
    "-DSYSTEM_XXHASH=ON"
    "-DSYSTEM_ZSTD=ON"
    "-DENABLE_HYPERSCAN=ON"
  ]
  ++ lib.optional (!withLuaJIT) "-DENABLE_LUAJIT=OFF";

  passthru.tests.rspamd = nixosTests.rspamd;

  meta = {
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
