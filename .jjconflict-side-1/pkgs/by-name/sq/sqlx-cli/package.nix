{
  stdenv,
  lib,
  rustPlatform,
  fetchCrate,
  installShellFiles,
  pkg-config,
  openssl,
  libiconv,
  testers,
  sqlx-cli,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sqlx-cli";
  version = "0.9.0";

  # Upstream stopped shipping a Cargo.lock starting with the v0.9.0 release
  # https://github.com/transact-rs/sqlx/blob/v0.9.0/CHANGELOG.md#cargolock-removed-from-tracking
  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-XariusjsCgn0Qai0XWtr7EzSzDDTp1cCzjff1kJNO9Y=";
  };

  cargoHash = "sha256-pHaMKuB9v3fjbgeVyLyRtfoQ9BkE6z+TjDfdBaVdbXM=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "native-tls"
    "postgres"
    "sqlite"
    "mysql"
    "completions"
    "sqlx-toml"
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/sqlx completions $shell > sqlx.$shell
      installShellCompletion sqlx.$shell
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = sqlx-cli;
    command = "sqlx --version";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for managing databases, migrations, and enabling offline mode with `sqlx::query!()` and friends";
    homepage = "https://github.com/transact-rs/sqlx";
    changelog = "https://github.com/transact-rs/sqlx/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      greizgh
      xrelkd
      fd
    ];
    mainProgram = "sqlx";
  };
})
