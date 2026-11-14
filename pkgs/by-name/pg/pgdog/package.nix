{
  aws-lc,
  bison,
  lib,
  clangStdenv,
  fetchFromGitHub,
  flex,
  icu,
  openssl,
  perl,
  pkg-config,
  readline,
  rustPlatform,
  rust-jemalloc-sys-unprefixed,
  useMoldLinker,
  versionCheckHook,
  withMold ? with clangStdenv.hostPlatform; isLinux,
  zlib,
}:
let
  stdenv = if withMold then useMoldLinker clangStdenv else clangStdenv;
in
rustPlatform.buildRustPackage.override { inherit stdenv; } (finalAttrs: {
  pname = "pgdog";
  version = "0.1.65";

  src = fetchFromGitHub {
    owner = "pgdogdev";
    repo = "pgdog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/R5g0UenVd+CBXjnkkWiF6pHRxYKTtG6QakH0tgA/vM=";
  };

  cargoHash = "sha256-oKJmgx6FeIxn5z/W6gfl0RKXfMZiRUd2A4cpSEnFeDU=";

  # Hardcoded paths for C compiler and linker
  postPatch = ''
    rm .cargo/config.toml
  '';

  env.RUSTFLAGS = "--cfg tokio_unstable";
  cargoBuildFlags = [
    "--package"
    "pgdog"
  ];

  nativeBuildInputs = [
    bison
    flex
    perl
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    aws-lc
    icu
    openssl
    readline
    zlib
    rust-jemalloc-sys-unprefixed
  ];

  # Several tests rely on networking
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "PostgreSQL connection pooler, load balancer, and database sharder";
    homepage = "https://pgdog.dev/";
    changelog = "https://github.com/pgdogdev/pgdog/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "pgdog";
    maintainers = with lib.maintainers; [ EpicEric ];
    platforms = lib.platforms.all;
  };
})
