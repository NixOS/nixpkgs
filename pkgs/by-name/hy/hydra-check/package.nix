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
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "hydra-check";
    tag = "v${version}";
    hash = "sha256-FfeT6oxhHORbd4uR4gRNhI6W9YOkG8ieiL0Co3GWzb4=";
  };

  cargoHash = "sha256-35e+ACUyp5sQiHz9fgDXXz365XbxHMLcX2aTA41rJN0=";

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
