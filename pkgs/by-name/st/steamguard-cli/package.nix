{
  installShellFiles,
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "steamguard-cli";
  version = "0.18.4";

  src = fetchFromGitHub {
    owner = "dyc3";
    repo = "steamguard-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zjkFVsc0ANXUYNH0tqFewz0xJSCm9Gyo5Ruy+sJJKrg=";
  };

  cargoHash = "sha256-wEnUCmFX+VGdkwE1ivoCI+BtOr7BI1qY9sQH4IVSiSY=";

  # disable update check
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "keyring"
    "qr"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd steamguard \
      --bash <($out/bin/steamguard completion --shell bash) \
      --fish <($out/bin/steamguard completion --shell fish) \
      --zsh <($out/bin/steamguard completion --shell zsh)
  '';

  meta = {
    changelog = "https://github.com/dyc3/steamguard-cli/releases/tag/v${finalAttrs.version}";
    description = "Linux utility for generating 2FA codes for Steam and managing Steam trade confirmations";
    homepage = "https://github.com/dyc3/steamguard-cli";
    license = lib.licenses.gpl3Only;
    mainProgram = "steamguard";
    maintainers = with lib.maintainers; [
      surfaceflinger
      sigmasquadron
    ];
    platforms = lib.platforms.linux;
  };
})
