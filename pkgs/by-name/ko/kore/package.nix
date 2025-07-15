{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  openssl,
  curl,
  libpq,
  yajl,
}:

stdenv.mkDerivation rec {
  pname = "kore";
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "jorisvink";
    repo = "kore";
    rev = version;
    sha256 = "sha256-p0M2P02xwww5EnT28VnEtj5b+/jkPW3YkJMuK79vp4k=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/jorisvink/kore/commit/978cb0ab79c9c939c35996f34f7d835f9c671831.patch";
      hash = "sha256-uHTWiliM4m2i9/6GQQfnAo31XBXd/2+fzysPeNo2dQ0=";
    })
    (fetchpatch {
      url = "https://github.com/jorisvink/kore/commit/6122affe22bf676eed0f544e421c53699aa7a2e2.patch";
      hash = "sha256-xaiUOjBJPEgEwwuseXe6VbOTkOCKdQ5tuwDdL7DojHM=";
    })
  ];

  buildInputs = [
    openssl
    curl
    libpq
    yajl
  ];

  nativeBuildInputs = [
    libpq.pg_config
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ACME=1"
    "CURL=1"
    "TASKS=1"
    "PGSQL=1"
    "JSONRPC=1"
    "DEBUG=1"
  ];

  preBuild = ''
    make platform.h
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-Wno-error=deprecated-declarations"
    ]
    ++ lib.optionals stdenv.cc.isGNU [
      "-Wno-error=pointer-compare"
      "-Wno-error=discarded-qualifiers"
    ]
    ++ lib.optionals stdenv.cc.isClang [
      "-Wno-error=incompatible-pointer-types-discards-qualifiers"
    ]
  );

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Easy to use web application framework for C";
    homepage = "https://kore.io";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ johnmh ];
  };
}
