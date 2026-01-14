{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "cirrus-cli";
  version = "0.159.1";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = "cirrus-cli";
    rev = "v${version}";
    hash = "sha256-Zf7muVwJQzye5YEeQtRbHQ2SmFFap7BMze9YuJv1ABU=";
  };

  vendorHash = "sha256-n2Bmx4EJ+L6+rlvfG/2FD4Ua9bG9GVcnvD+QPfQg/HE=";

  ldflags = [
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Version=v${version}"
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Commit=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cirrus \
      --bash <($out/bin/cirrus completion bash) \
      --zsh <($out/bin/cirrus completion zsh) \
      --fish <($out/bin/cirrus completion fish)
  '';

  # tests fail on read-only filesystem
  doCheck = false;

  meta = {
    description = "CLI for executing Cirrus tasks locally and in any CI";
    homepage = "https://github.com/cirruslabs/cirrus-cli";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ techknowlogick ];
    mainProgram = "cirrus";
  };
}
