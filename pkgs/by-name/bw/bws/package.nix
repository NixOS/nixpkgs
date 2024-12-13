{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  oniguruma,
  openssl,
  stdenv,
  darwin,
  python3,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "bws";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "bws-v${version}";
    hash = "sha256-acS4yKppvIBiwBMoa5Ero4G9mUf8OLG/TbrZOolAwuc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "passkey-0.2.0" = "sha256-dCQUu4lWqdQ6EiNLPRVHL1dLVty4r8//ZQzV8XCBhmY=";
    };
  };

  nativeBuildInputs =
    [
      installShellFiles
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      perl
    ];

  buildInputs =
    [
      oniguruma
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    PYO3_PYTHON = "${python3}/bin/python3";
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  cargoBuildFlags = [
    "--package"
    "bws"
  ];

  cargoTestFlags = [
    "--package"
    "bws"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bws \
      --bash <($out/bin/bws completions bash) \
      --fish <($out/bin/bws completions fish) \
      --zsh <($out/bin/bws completions zsh)
  '';

  meta = {
    changelog = "https://github.com/bitwarden/sdk/blob/${src.rev}/crates/bws/CHANGELOG.md";
    description = "Bitwarden Secrets Manager CLI";
    homepage = "https://bitwarden.com/help/secrets-manager-cli/";
    license = lib.licenses.unfree; # BITWARDEN SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT
    mainProgram = "bws";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
