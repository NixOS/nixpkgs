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
  postgresql,
  libxml2,
  libyaml,
  zlib,
  libssh2,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "pgbackrest";
  version = "2.54.1";

  src = fetchFromGitHub {
    owner = "pgbackrest";
    repo = "pgbackrest";
    rev = "release/${version}";
    sha256 = "sha256-kzFTWKzBQ0Jfew8oV+iaNAEx4lQncySyAI2VAgNu42s=";
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
    postgresql
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
