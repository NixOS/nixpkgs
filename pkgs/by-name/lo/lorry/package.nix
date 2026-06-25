{
  lib,
  rustPlatform,
  fetchFromGitLab,
  nix-update-script,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  openssl,
  sqlite,

  # Test dependency for SQL queries
  sqlx-cli,

  # nativeCheckInputs
  addBinToPathHook,
  versionCheckHook,
  gitMinimal,

  # Optional features (GitHub mirroring)
  withGitHub ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lorry";
  version = "3.0.0";

  src = fetchFromGitLab {
    group = "CodethinkLabs";
    owner = "lorry";
    repo = "lorry2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jdPQBQY3XbExFzTb/VVi65A/EcmdjY0pUvCh53BiCrI=";
  };

  cargoHash = "sha256-mBJeuI0FnYL3DEqSQQUuXdVzfuhZxNRiRqbl8EvxKjI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  buildFeatures = lib.optional withGitHub "github";

  env = {
    OPENSSL_NO_VENDOR = 1;
    SQLX_OFFLINE = true;
  };

  nativeCheckInputs = [
    addBinToPathHook
    versionCheckHook
    gitMinimal
    sqlx-cli
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9]+)$"
    ];
  };

  __structuredAttrs = true;

  meta = {
    changelog = "https://gitlab.com/CodethinkLabs/lorry/lorry2/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "High performance software asset mirroring system.";
    downloadPage = "https://gitlab.com/CodethinkLabs/lorry/lorry2";
    homepage = "https://lorry.software";
    license = lib.licenses.asl20;
    mainProgram = "lorry";
    maintainers = with lib.maintainers; [ shymega ];
    platforms = lib.platforms.linux;
  };
})
