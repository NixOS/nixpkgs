{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  oniguruma,
  openssl,
  stdenv,
  python3,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bws";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    tag = "bws-v${finalAttrs.version}";
    hash = "sha256-cdiTdgNvUDN0/KzMDEiHo+GIYkUaWEZTAnWahBrMZ4I=";
  };

  cargoHash = "sha256-zT6yPRxPuIf0E7OoUH4qQkUPADsYdkPirJ8dR/o5fV0=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    perl
  ];

  buildInputs = [
    oniguruma
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    openssl
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
    for shell in bash fish zsh; do
      installShellCompletion --cmd bws --"$shell" <($out/bin/bws completions "$shell")
    done
  '';

  meta = {
    description = "Bitwarden Secrets Manager CLI";
    homepage = "https://bitwarden.com/help/secrets-manager-cli/";
    changelog = "https://github.com/bitwarden/sdk-sm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unfree; # BITWARDEN SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "bws";
  };
})
