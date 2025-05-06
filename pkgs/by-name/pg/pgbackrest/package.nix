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
  version = "2.55.0";

  src = fetchFromGitHub {
    owner = "pgbackrest";
    repo = "pgbackrest";
    rev = "release/${version}";
    sha256 = "sha256-w4jgIyZPglmI0yj8eyoIvFgNX7izpo3lBixuv7qSAxM=";
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
