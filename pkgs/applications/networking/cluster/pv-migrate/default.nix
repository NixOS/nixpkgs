{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "pv-migrate";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-J4GsXLff9OQNiLv3AvBLtmz383E2JPEB3VEN3nzE5R8=";
  };

  subPackages = [ "cmd/pv-migrate" ];

  vendorHash = "sha256-PzmNCBTw9AfDUBh/tWlukH5EGJffEBCBT1gJTMIZRO0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
    "-X main.commit=${src.rev}"
    "-X main.date=1970-01-01-00:00:01"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd pv-migrate \
      --bash <($out/bin/pv-migrate completion bash) \
      --fish <($out/bin/pv-migrate completion fish) \
      --zsh <($out/bin/pv-migrate completion zsh)
  '';

  meta = with lib; {
    description = "CLI tool to easily migrate Kubernetes persistent volumes ";
    homepage = "https://github.com/utkuozdemir/pv-migrate";
    changelog = "https://github.com/utkuozdemir/pv-migrate/releases/tag/${version}";
    license = licenses.afl20;
    maintainers = with lib.maintainers; [ ivankovnatsky qjoly ];
  };
}
