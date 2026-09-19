{
  bison,
  fetchFromGitHub,
  flex,
  icu,
  lib,
  libuuid,
  libxml2,
  lz4,
  openssl,
  pkg-config,
  readline,
  stdenv,
  testers,
  tzdata,
  zlib,
  zstd,
}: let
  pgvectorVersion = "0.7.4";
  pgvectorSrc = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector";
    rev = "v${pgvectorVersion}";
    hash = "sha256-qwPaguQUdDHV8q6GDneLq5MuhVroPizpbqt7f08gKJI=";
  };
  # edb_stat_statements ships only in-tree with the server (same rev as
  # gel-server); the whole source is fetched once and the subdirectory
  # is used below.
  gelSrc = fetchFromGitHub {
    owner = "geldata";
    repo = "gel";
    rev = "e0ef1b92dec1910bb40585c7a818944c4717ec29";
    hash = "sha256-1VmaVEwFpt2ZpAQzH/9ravn4D51gyEGBeeDBu1pyHwk=";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "gel-postgresql";
    # Upstream PostgreSQL version the fork tracks; the Gel fork revision is
    # recorded below and moves together with gel-server releases.
    version = "17.4";

    src = fetchFromGitHub {
      owner = "geldata";
      repo = "postgres";
      rev = "7e30cce01231dce7966b6ea68349cc89f176c2df";
      hash = "sha256-D970XpDkgS06zzYkh1IGsmRSkXiW+Fy9HwT8JwZ+k64=";
    };

    patches = [
      # NixOS socket-directory conventions (same as stock postgresql;
      # vendored: by-name packages must be self-contained).
      ./socketdir-in-run-13+.patch
    ];

    nativeBuildInputs = [
      bison
      flex
      pkg-config
    ];

    buildInputs = [
      icu
      libuuid
      libxml2
      lz4
      openssl
      readline
      tzdata
      zlib
      zstd
    ];

    # Lean, server-managed-clusters-only feature set: no JIT (the Gel server
    # sets jit=off itself), no systemd/PAM/PLs/GSSAPI (scram/file auth only).
    # Mirrors stock postgresql_17 flags otherwise for maximal compatibility.
    configureFlags = [
      "--with-openssl"
      "--with-icu"
      "--sysconfdir=/etc"
      "--with-system-tzdata=${tzdata}/share/zoneinfo"
      "--with-uuid=e2fs"
      "--with-lz4"
      "--with-zstd"
    ];

  env.NIX_CFLAGS_COMPILE = "-UUSE_PRIVATE_ENCODING_FUNCS";

  strictDeps = true;
  __structuredAttrs = true;

  enableParallelBuilding = true;

    postInstall = ''
      # Gel-coupled extensions, built exactly like upstream's in-tree build
      # (make PG_CONFIG=..., pgvector with OPT_FLAGS= to defeat -march=native).
      cp -r ${pgvectorSrc} pgvector
      chmod -R u+w pgvector
      make -C pgvector PG_CONFIG=$out/bin/pg_config OPT_FLAGS=
      make -C pgvector install PG_CONFIG=$out/bin/pg_config OPT_FLAGS=
      cp -r ${gelSrc}/edb_stat_statements edb_stat_statements
      chmod -R u+w edb_stat_statements
      make -C edb_stat_statements PG_CONFIG=$out/bin/pg_config
      make -C edb_stat_statements install PG_CONFIG=$out/bin/pg_config
    '';

    passthru.tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "postgres --version";
    };

    meta = {
      description = "PostgreSQL fork for the Gel server (plus pgvector and edb_stat_statements)";
      longDescription = ''
        Gel-tracked PostgreSQL 17 fork at the revision Gel v7.1 builds
        against, with the Gel-coupled extensions (pgvector,
        edb_stat_statements) built into the same installation, mirroring
        upstream's in-tree build. Usable only by gel-server; not a general
        PostgreSQL. No update script: fork revisions move together with
        gel-server releases.
      '';
      homepage = "https://github.com/geldata/postgres";
      license = lib.licenses.postgresql;
      # Linux-only review scope; Darwin builds are untested, do not advertise.
      platforms = lib.platforms.linux;
    };
  })
