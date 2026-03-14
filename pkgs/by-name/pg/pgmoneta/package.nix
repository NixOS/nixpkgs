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

stdenv.mkDerivation (finalAttrs: {
  pname = "pgmoneta";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "pgmoneta";
    repo = "pgmoneta";
    rev = finalAttrs.version;
    hash = "sha256-qsKjUFCuxKSc7klB/S2N3TG+jqnS4NW0RZC6e9JQXtA=";
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
    changelog = "https://github.com/pgmoneta/pgmoneta/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
