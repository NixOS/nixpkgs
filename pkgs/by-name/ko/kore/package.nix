{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  curl,
  postgresql_16,
  yajl,
}:

stdenv.mkDerivation rec {
  pname = "kore";
  # TODO: Check on next update whether postgresql 17 is supported.
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "jorisvink";
    repo = pname;
    rev = version;
    sha256 = "sha256-p0M2P02xwww5EnT28VnEtj5b+/jkPW3YkJMuK79vp4k=";
  };

  buildInputs = [
    openssl
    curl
    postgresql_16
    yajl
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
