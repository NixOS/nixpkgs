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
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "redislabs";
    repo = "memtier_benchmark";
    tag = finalAttrs.version;
    hash = "sha256-/t7OY3N9VBa9o2amOFb2/MUr5Y4ep4HGUil8OtwKkng=";
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
    homepage = "https://github.com/redislabs/memtier_benchmark";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    mainProgram = "memtier_benchmark";
  };
})
