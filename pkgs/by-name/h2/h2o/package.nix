{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  ninja,
  perl,
  brotli,
  openssl,
  libcap,
  libuv,
  wslay,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "h2o";
  version = "2.3.0.20250130";

  src = fetchFromGitHub {
    owner = "h2o";
    repo = "h2o";
    rev = "26b116e9536be8cf07036185e3edf9d721c9bac2";
    sha256 = "sha256-WjsUUnSs3kXjAmh+V/lzL1QlxxXNCph99UsC29YAirQ=";
  };

  outputs = [
    "out"
    "man"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    perl
  ];
  buildInputs = [
    brotli
    openssl
    libcap
    libuv
    zlib
    wslay
  ];

  meta = with lib; {
    description = "Optimized HTTP/1.x, HTTP/2, HTTP/3 server";
    homepage = "https://h2o.examp1e.net";
    license = licenses.mit;
    maintainers = with maintainers; [
      toastal
      thoughtpolice
    ];
    mainProgram = "h2o";
    platforms = platforms.linux;
  };
})
