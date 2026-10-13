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
  libyaml,
  lz4,
  ncurses,
  openssl,
  pkg-config,
  systemd,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgmoneta";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "pgmoneta";
    repo = "pgmoneta";
    rev = finalAttrs.version;
    hash = "sha256-55oXnyNLwhtT3s4qTEh24N08vf0zhNUDVoxrUiYkVZc=";
  };

  nativeBuildInputs = [
    cmake
    docutils # for rst2man
    pkg-config
  ];

  buildInputs = [
    bzip2
    cjson
    curl
    libarchive
    libev
    libgccjit
    libssh
    libyaml
    lz4
    ncurses
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
