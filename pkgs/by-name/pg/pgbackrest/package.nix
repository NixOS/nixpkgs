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
  systemdLibs,
  zlib,
  zstd,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgbackrest";
  version = "2.60.1";

  src = fetchFromGitHub {
    owner = "pgbackrest";
    repo = "pgbackrest";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-F/BAvdmUhXavvj75IY7lN+WhK4o4WwSH5wrDOsYHQcw=";
  };

  strictDeps = true;

  # The source tree ships a top-level build/ directory; with meson's default
  # build directory (source/build) meson 1.12 mis-resolves ../../.. paths in
  # depend_files, so keep the build directory outside the source tree.
  mesonBuildDir = "../build";

  postPatch = ''
    patchShebangs --build build/build.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    # build.py code generator needs PyYAML
    (python3.withPackages (ps: [ ps.pyyaml ]))
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ systemdLibs ];

  mesonFlags = lib.optionals (!stdenv.hostPlatform.isLinux) [ "-Dlibsystemd=disabled" ];

  passthru.tests = nixosTests.pgbackrest;

  meta = {
    description = "Reliable PostgreSQL backup & restore";
    homepage = "https://pgbackrest.org";
    changelog = "https://github.com/pgbackrest/pgbackrest/releases/tag/release%2F${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "pgbackrest";
    maintainers = with lib.maintainers; [
      gautema
      zaninime
    ];
  };
})
