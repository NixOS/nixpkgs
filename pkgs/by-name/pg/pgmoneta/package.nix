{
  lib,
  stdenv,
  bzip2,
  cjson,
  cmake,
  curl,
  docutils,
  fetchFromGitHub,
  libarchive,
  libev,
  libgccjit,
  libssh,
  lz4,
  openssl,
  systemd,
  zlib,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "pgmoneta";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "pgmoneta";
    repo = "pgmoneta";
    rev = version;
    hash = "sha256-5yatgiNl9szTnZbn6nKaGKgfnm2bOG4gvXGN5SqtbJI=";
  };

  nativeBuildInputs = [
    cmake
    docutils # for rst2man
  ];

  buildInputs = [
    bzip2
    cjson
    curl
    libarchive
    libev
    libgccjit
    libssh
    lz4
    openssl
    systemd
    zlib
    zstd
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = {
    description = "Backup / restore solution for PostgreSQL";
    homepage = "https://pgmoneta.github.io/";
    changelog = "https://github.com/pgmoneta/pgmoneta/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
