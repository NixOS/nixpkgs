{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  fioctl,
}:

buildGoModule rec {
  pname = "fioctl";
  version = "0.45";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${version}";
    sha256 = "sha256-t2jafaqaO6T008F7UcdGhJ2TkEXpXLBHphcy17ZMByQ=";
  };

  vendorHash = "sha256-gwowkIdkZDxrTsIrXF9obtkZ3lAAny+msd8TTTX0q5g=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/foundriesio/fioctl/subcommands/version.Commit=${src.rev}"
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
    version = "v${version}";
  };

  meta = {
    description = "Simple CLI to manage your Foundries Factory";
    homepage = "https://github.com/foundriesio/fioctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nixinator
      matthewcroughan
    ];
    mainProgram = "fioctl";
  };
}
