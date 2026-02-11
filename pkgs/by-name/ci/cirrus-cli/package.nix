{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "cirrus-cli";
  version = "0.163.2";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = "cirrus-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x/SwCCgW3wZnQ0VwVUinfPXiBexKdfvFGMFiBdmApFI=";
  };

  vendorHash = "sha256-7xjt1TP+Wei+iEiCJMn7XyzW4RV2GNf+xX5O3tnXFvc=";

  ldflags = [
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Version=v${finalAttrs.version}"
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Commit=v${finalAttrs.version}"
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
})
