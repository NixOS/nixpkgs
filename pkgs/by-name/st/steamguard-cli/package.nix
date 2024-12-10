{
  installShellFiles,
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "steamguard-cli";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "dyc3";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+Lax9MaNyrsckgx7HtpXC1zBWcZNt16inY8qil0CVLQ=";
  };

  cargoHash = "sha256-4QyFNy7oGWKScKZXQc63TxsI3avyEVSlqJAmv+lg1GE=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd steamguard \
      --bash <($out/bin/steamguard completion --shell bash) \
      --fish <($out/bin/steamguard completion --shell fish) \
      --zsh <($out/bin/steamguard completion --shell zsh) \
  '';

  meta = with lib; {
    changelog = "https://github.com/dyc3/steamguard-cli/releases/tag/v${version}";
    description = "A linux utility for generating 2FA codes for Steam and managing Steam trade confirmations.";
    homepage = "https://github.com/dyc3/steamguard-cli";
    license = with licenses; [ gpl3Only ];
    mainProgram = "steamguard";
    maintainers = with maintainers; [ surfaceflinger ];
    platforms = platforms.linux;
  };
}
