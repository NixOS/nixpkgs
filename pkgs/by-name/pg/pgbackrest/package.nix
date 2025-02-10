{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  python3,
  pkg-config,
  libbacktrace,
  bzip2,
  lz4,
  libpq,
  libxml2,
  libyaml,
  zlib,
  libssh2,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "pgbackrest";
  version = "2.54.2";

  src = fetchFromGitHub {
    owner = "pgbackrest";
    repo = "pgbackrest";
    rev = "release/${version}";
    sha256 = "sha256-Q0WZLbtn+qJLs2jop5S92NFC6QBtCQnU3AEEcm6MSVI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    python3
    pkg-config
  ];

  buildInputs = [
    libbacktrace
    bzip2
    lz4
    libpq
    libxml2
    libyaml
    zlib
    libssh2
    zstd
  ];

  meta = with lib; {
    description = "Reliable PostgreSQL backup & restore";
    homepage = "https://pgbackrest.org/";
    changelog = "https://github.com/pgbackrest/pgbackrest/releases";
    license = licenses.mit;
    mainProgram = "pgbackrest";
    maintainers = with maintainers; [ zaninime ];
  };
}
