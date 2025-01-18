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

stdenv.mkDerivation rec {
  pname = "memtier-benchmark";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "redislabs";
    repo = "memtier_benchmark";
    tag = version;
    sha256 = "sha256-3q+NOdmbOiRq+pUxy3d1UdpUxHsv2XfnScDIfB+xyhk=";
  };

  patchPhase = ''
    substituteInPlace ./configure.ac \
      --replace '1.2.8' '${version}'
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

  meta = with lib; {
    description = "Redis and Memcached traffic generation and benchmarking tool";
    homepage = "https://github.com/redislabs/memtier_benchmark";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "memtier_benchmark";
  };
}
