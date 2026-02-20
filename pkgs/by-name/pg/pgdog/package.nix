{
  lib,
  clangStdenv,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  useMoldLinker,
  versionCheckHook,
  withMold ? with clangStdenv.hostPlatform; isUnix && !isDarwin,
}:
let
  stdenv = if withMold then useMoldLinker clangStdenv else clangStdenv;
in
rustPlatform.buildRustPackage.override { inherit stdenv; } (finalAttrs: {
  pname = "pgdog";
  version = "0.1.29";

  src = fetchFromGitHub {
    owner = "pgdogdev";
    repo = "pgdog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8aFBb+bkdht0aQmqSwEy266rQM3iuE2vpqgtZzbhszU=";
  };

  cargoHash = "sha256-IjVVHDHm7qe0w8HvsmZb7u830EFXZDcYmlpqpqjLzSk=";

  # Hardcoded paths for C compiler and linker
  postPatch = ''
    rm .cargo/config.toml
  '';

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
