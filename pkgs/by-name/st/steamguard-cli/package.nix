{
  installShellFiles,
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "steamguard-cli";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "dyc3";
    repo = "steamguard-cli";
    rev = "v${version}";
    hash = "sha256-IoWLPpFPQC1QU1EgJSiiAQqMcDQnHa5WRLiya3WN+6w=";
  };

  cargoHash = "sha256-7csGZp5dAz0j7pTxeex/yrgzNFU7Qz3zNcZ/K4dV7GE=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd steamguard \
      --bash <($out/bin/steamguard completion --shell bash) \
      --fish <($out/bin/steamguard completion --shell fish) \
      --zsh <($out/bin/steamguard completion --shell zsh) \
  '';

  meta = {
    changelog = "https://github.com/dyc3/steamguard-cli/releases/tag/v${version}";
    description = "Linux utility for generating 2FA codes for Steam and managing Steam trade confirmations";
    homepage = "https://github.com/dyc3/steamguard-cli";
    license = with lib.licenses; [ gpl3Only ];
    mainProgram = "steamguard";
    maintainers = with lib.maintainers; [
      surfaceflinger
      sigmasquadron
    ];
    platforms = lib.platforms.linux;
  };
}
