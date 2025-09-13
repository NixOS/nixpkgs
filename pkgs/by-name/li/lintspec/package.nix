{
  fetchFromGitHub,
  installShellFiles,
  lib,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "lintspec";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "lintspec";
    tag = "v${version}";
    hash = "sha256-5jNOMAohfzq/S+1LASQh0hvzqdMLQGdPYSb6rcGxmD8=";
  };

  cargoHash = "sha256-m9n9r3SJtGx3/MURmZak2XRCLkmQZU06nPMQpROfvVs=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lintspec \
      --bash <($out/bin/lintspec completions -s bash) \
      --fish <($out/bin/lintspec completions -s fish) \
      --zsh <($out/bin/lintspec completions -s zsh)
  '';

  meta = {
    description = "Blazingly fast linter for NatSpec comments in Solidity code";
    homepage = "https://github.com/beeb/lintspec";
    changelog = "https://github.com/beeb/lintspec/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ beeb ];
    mainProgram = "lintspec";
  };
}
