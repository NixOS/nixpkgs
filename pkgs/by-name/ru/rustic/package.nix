{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustic";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "rustic-rs";
    repo = "rustic";
    tag = "v${version}";
    hash = "sha256-IyAfaCeppmIKrnEb/RxNV3nNYLjlZR28u5HXNbyc8wc=";
  };

  cargoHash = "sha256-wkI38C0ol0q5od+mbmr8JVekLMGEyWT+eQyy9kILyFs=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rustic \
      --bash <($out/bin/rustic completions bash) \
      --fish <($out/bin/rustic completions fish) \
      --zsh <($out/bin/rustic completions zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/rustic-rs/rustic";
    changelog = "https://github.com/rustic-rs/rustic/blob/${src.rev}/CHANGELOG.md";
    description = "Fast, encrypted, deduplicated backups powered by pure Rust";
    mainProgram = "rustic";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = [
      lib.maintainers.nobbz
      lib.maintainers.pmw
    ];
  };
}
