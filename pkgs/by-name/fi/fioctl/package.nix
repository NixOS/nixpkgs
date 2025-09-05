{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  fioctl,
}:

buildGoModule rec {
  pname = "fioctl";
  version = "0.44";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${version}";
    sha256 = "sha256-+eoXD8VeSjzTrTJFJvbEpA6T/ISO4qh3XG14bX/u7pY=";
  };

  vendorHash = "sha256-gwowkIdkZDxrTsIrXF9obtkZ3lAAny+msd8TTTX0q5g=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/foundriesio/fioctl/subcommands/version.Commit=${src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
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

  meta = with lib; {
    description = "Simple CLI to manage your Foundries Factory";
    homepage = "https://github.com/foundriesio/fioctl";
    license = licenses.asl20;
    maintainers = with maintainers; [
      nixinator
      matthewcroughan
    ];
    mainProgram = "fioctl";
  };
}
