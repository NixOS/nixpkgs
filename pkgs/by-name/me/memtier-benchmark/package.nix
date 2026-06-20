{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libevent,
  zlib,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "memtier-benchmark";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "memtier_benchmark";
    tag = finalAttrs.version;
    hash = "sha256-0whioOhzs5aLu/fjRJvybZ8UYE5Lv1VnQDmgikC3tEA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libevent
    zlib
    openssl
  ];

  meta = {
    changelog = "https://github.com/redis/memtier_benchmark/releases/tag/${finalAttrs.version}";
    description = "Redis and Memcached traffic generation and benchmarking tool";
    homepage = "https://github.com/redis/memtier_benchmark";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      hythera
    ];
    mainProgram = "memtier_benchmark";
  };
})
