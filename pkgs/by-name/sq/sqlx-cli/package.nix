{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  libiconv,
  testers,
  sqlx-cli,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "sqlx-cli";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v${version}";
    hash = "sha256-R6T8sXuHlunXvqxQ95EKd+fdkPUZU8nTFkg9WBJWeRA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ILv9sVBKhF+KDPfTsxYorRlx33tPolNE8KSNdNajzBc=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "native-tls"
    "postgres"
    "sqlite"
    "mysql"
    "completions"
  ];

  doCheck = false;
  cargoBuildFlags = [ "--package sqlx-cli" ];

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

  meta = with lib; {
    description = "SQLx's associated command-line utility for managing databases, migrations, and enabling offline mode with sqlx::query!() and friends.";
    homepage = "https://github.com/launchbadge/sqlx";
    license = licenses.asl20;
    maintainers = with maintainers; [
      greizgh
      xrelkd
      fd
    ];
    mainProgram = "sqlx";
  };
}
