{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  fioctl,
}:

buildGoModule (finalAttrs: {
  pname = "fioctl";
  version = "0.47";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-H449wAeJkInc0J/1DwvdCO/38hpZIgMex0tfcO1004E=";
  };

  vendorHash = "sha256-Q0hQg8n1CS+Q6fOmwiSzT48+8irjCexNT441k//VSVE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/foundriesio/fioctl/subcommands/version.Commit=${finalAttrs.src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fioctl \
      --bash <($out/bin/fioctl completion bash) \
      --fish <($out/bin/fioctl completion fish) \
      --zsh <($out/bin/fioctl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = fioctl;
    command = "HOME=$(mktemp -d) fioctl version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Simple CLI to manage your Foundries Factory";
    homepage = "https://github.com/foundriesio/fioctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      matthewcroughan
    ];
    mainProgram = "fioctl";
  };
})
