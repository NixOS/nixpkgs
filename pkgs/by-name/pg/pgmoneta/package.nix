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
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "pgmoneta";
    repo = "pgmoneta";
    rev = version;
    hash = "sha256-UMsINV0Atl1bWN4v9XfuwDkxNJCye8R8V8n0EnHf2w0=";
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

  meta = with lib; {
    description = "Backup / restore solution for PostgreSQL";
    homepage = "https://pgmoneta.github.io/";
    changelog = "https://github.com/pgmoneta/pgmoneta/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
