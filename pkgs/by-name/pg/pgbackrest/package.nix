{
  bzip2,
  fetchFromGitHub,
  lib,
  libbacktrace,
  libpq,
  libssh2,
  libxml2,
  libyaml,
  lz4,
  meson,
  ninja,
  pkg-config,
  python3,
  stdenv,
  zlib,
  zstd,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgbackrest";
  version = "2.56.0";

  src = fetchFromGitHub {
    owner = "pgbackrest";
    repo = "pgbackrest";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-GDHpeTz85cgKTbcuaTlwJ1SUNMedSylqKWdrgH8Zp8Q=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    bzip2
    libbacktrace
    libpq
    libssh2
    libxml2
    libyaml
    lz4
    zlib
    zstd
  ];

  passthru.tests = nixosTests.pgbackrest;

  meta = {
    description = "Reliable PostgreSQL backup & restore";
    homepage = "https://pgbackrest.org";
    changelog = "https://github.com/pgbackrest/pgbackrest/releases/tag/release%2F${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "pgbackrest";
    maintainers = with lib.maintainers; [
      zaninime
      iedame
    ];
  };
})
