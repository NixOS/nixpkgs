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
  version = "0.46";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8IzDEj8GO+CskEdwmDqRFZ6XwQ39uy8Ujh7enQQ8QW4=";
  };

  vendorHash = "sha256-vX1Bg09xjUiDKcrEwlLRZvqh6md6/MO3Uhk69rDGYiM=";

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
