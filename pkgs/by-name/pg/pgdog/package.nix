{
  lib,
  clangStdenv,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  useMoldLinker,
  versionCheckHook,
  withMold ? with clangStdenv.hostPlatform; isLinux,
}:
let
  stdenv = if withMold then useMoldLinker clangStdenv else clangStdenv;
in
rustPlatform.buildRustPackage.override { inherit stdenv; } (finalAttrs: {
  pname = "pgdog";
  version = "0.1.52";

  src = fetchFromGitHub {
    owner = "pgdogdev";
    repo = "pgdog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k2M5D4/g/NqCC34lnzNmTO0v5rTNClBA94rUlHdYEno=";
  };

  cargoHash = "sha256-lKDaBpbfNmOox96KVwh2MGj5u6V2Ak3g2vSrombUChI=";

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
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ];

  strictDeps = true;

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
