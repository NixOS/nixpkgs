{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "hydra-check";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "hydra-check";
    rev = "v${version}";
    hash = "sha256-QdCXToHNymOdlTyQjk9eo7LTznGKB+3pIOgjjaGoTXg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zjpsMuwOdDm4St8M0h4yoJhTirgANJ6s5hfbayyq/uE=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hydra-check \
      --bash <($out/bin/hydra-check --shell-completion bash) \
      --fish <($out/bin/hydra-check --shell-completion fish) \
      --zsh <($out/bin/hydra-check --shell-completion zsh)
  '';

  meta = {
    description = "Check hydra for the build status of a package";
    homepage = "https://github.com/nix-community/hydra-check";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      makefu
      artturin
      bryango
      doronbehar
    ];
    mainProgram = "hydra-check";
  };
}
