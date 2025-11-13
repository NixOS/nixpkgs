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
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "rustic-rs";
    repo = "rustic";
    tag = "v${version}";
    hash = "sha256-lyxm1GUFZBsJNsEaY+xiE55fbNAgRSG708GW10UVQ58=";
  };

  cargoHash = "sha256-rYfLfhxp29H5dRbnmmpN2/YpT79hhIruvIADNyP/lVs=";

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
