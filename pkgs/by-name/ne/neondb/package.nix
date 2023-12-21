{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,

  pkg-config, protobuf,
  postgresql_14, postgresql_15, postgresql_16,

  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "neondb";
  version = "4459";

  src = fetchFromGitHub {
    owner = "neondatabase";
    repo = "neon";
    rev = "release-${version}";
    hash = "sha256-TDinQACJkaE0xoVP+xYOYD41z6/FyG5s8t3pvj9+Y1U=";
  };

  # walproposer wants only postgresql_16, and generates some platform-dependent
  # code, based on platforms ABI. I have no idea how to make it work with crosscompilation.
  #
  # postgres-ffi generates code for v14, v15 and v16, I think we don't need all of them,
  # but in the time being we have dependency on 3 of them. Upstream changes are needed.
  # Generated code should be platform-independent, bindgen emits isize for size_t etc,
  # and postgres functions are the same between platforms.
  #
  # walproposer also wants to see libpgport.a at build/walproposer-lib path for some reason.
  postPatch = ''
    mkdir pg_install
    ln -s ${postgresql_14}/ pg_install/v14
    ln -s ${postgresql_15}/ pg_install/v15
    ln -s ${postgresql_16}/ pg_install/v16
    mkdir -p pg_install/build/walproposer-lib
    ln -s ${postgresql_16}/lib/lib{walproposer,pg{common,port}}.a pg_install/build/walproposer-lib/
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "heapless-0.8.0" = "sha256-phCls7RQZV0uYhDEp0GIphTBw0cXcurpqvzQCAionhs=";
      "postgres-0.19.4" = "sha256-rybhKZ5I6lsyiHdMlYZEaYawH6L4C8CcTH4/7vax8os=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ];
  cargoBuildFlags = [
    "--bin" "pg_sni_router"
    "--bin" "pageserver"
    "--bin" "pagectl"
    "--bin" "safekeeper"
    "--bin" "storage_broker"
    "--bin" "proxy"
    "--bin" "neon_local"
    "--bin" "compute_ctl"
  ];

  # Required setup is too complicated.
  doCheck = false;

  meta = {
    homepage = "https://neon.tech/";
    description = "Neon is a serverless open-source alternative to AWS Aurora Postgres. It separates storage and compute and substitutes the PostgreSQL storage layer by redistributing data across a cluster of nodes.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lach ];
    platforms = lib.platforms.unix;

    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}
