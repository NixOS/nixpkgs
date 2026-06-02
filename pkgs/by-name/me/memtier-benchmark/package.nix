{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libevent,
  pcre,
  zlib,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "memtier-benchmark";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "memtier_benchmark";
    tag = finalAttrs.version;
    hash = "sha256-N5oSAtlB8CSUSMQGxKHKHGakmUGJOq80LSkCdJw4H7U=";
  };

  patchPhase = ''
    substituteInPlace ./configure.ac \
      --replace '1.2.8' '${finalAttrs.version}'
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libevent
    pcre
    zlib
    openssl
  ];

  meta = {
    description = "Redis and Memcached traffic generation and benchmarking tool";
    homepage = "https://github.com/redis/memtier_benchmark";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    mainProgram = "memtier_benchmark";
  };
})
