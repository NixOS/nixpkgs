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
  version = "0.1.64";

  src = fetchFromGitHub {
    owner = "pgdogdev";
    repo = "pgdog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8jk7kBGiYsqVeMXpnLjUX9NM0C940QeNL+ePZ3rR9pg=";
  };

  cargoHash = "sha256-b/pIyN/Dp3xZQfO1GA31c6xmgxS/BopwHQcY3FxMaPo=";

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
