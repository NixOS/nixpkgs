{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  symlinkJoin,

  pkg-config,
  protobuf,
  postgresql_14_neon,
  postgresql_15_neon,
  postgresql_16_neon,
  postgresql_17_neon,

  openssl,
}:

let
  version = "9129";
  mergePg = name: pg: symlinkJoin { inherit name; paths = [ pg pg.dev pg.pg_config ]; };
  pg14 = mergePg "pg-neon-v14" postgresql_14_neon;
  pg15 = mergePg "pg-neon-v15" postgresql_15_neon;
  pg16 = mergePg "pg-neon-v16" postgresql_16_neon;
  pg17 = mergePg "pg-neon-v17" postgresql_17_neon;
in

rustPlatform.buildRustPackage {
  pname = "neondb";
  inherit version;

  src = fetchFromGitHub {
    owner = "neondatabase";
    repo = "neon";
    rev = "release-${version}";
    hash = "sha256-n5o4mHs6JJHTDTY0TnzRg3lKpSQKzYEe1nIXFGkRJJw=";
  };

  cargoHash = "sha256-C9EatnwZr+QjIzGa44bZPjMJptKLrpjCL2ZXJ+jpAeU=";

  # walproposer wants only postgresql_16, and generates some platform-dependent
  # code, based on platforms ABI. I have no idea how to make it work with crosscompilation.
  #
  # postgres-ffi generates code for v14, v15 and v16, I think we don't need all of them,
  # but in the time being we have dependency on 3 of them. Upstream changes are needed.
  # Generated code should be platform-independent, bindgen emits isize for size_t etc,
  # and postgres functions are the same between platforms.
  #
  # walproposer also wants to see libpgport.a at libs/walproposer-lib path for some reason.
  postPatch = ''
    mkdir pg_install
    ln -s ${pg14} pg_install/v14
    ln -s ${pg15} pg_install/v15
    ln -s ${pg16} pg_install/v16
    ln -s ${pg17} pg_install/v17
    mkdir -p pg_install/build/walproposer-lib
    ln -s ${pg17}/lib/lib{walproposer,pg{common,port}}.a pg_install/build/walproposer-lib/
  '';

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ];
  cargoBuildFlags = [
    "--bin"
    "pg_sni_router"
    "--bin"
    "proxy"
    "--bin"
    "pageserver"
    "--bin"
    "pagectl"
    "--bin"
    "safekeeper"
    "--bin"
    "storage_broker"
    "--bin"
    "storage_controller"
    "--bin"
    "storage_scrubber"
    "--bin"
    "storcon_cli"
    "--bin"
    "pagectl"
    "--bin"
    "compute_ctl"
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
