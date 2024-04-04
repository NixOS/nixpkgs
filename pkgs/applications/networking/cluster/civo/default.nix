{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "civo";
  version = "1.0.80";

  src = fetchFromGitHub {
    owner  = "civo";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "sha256-jzz9mny59YM5PLcQvcus3gHuRSbl/OISAOjDoS/4Y78=";
  };

  vendorHash = "sha256-Uh2/4qdJQfqQdjXbOBkUVv2nF1AN+QRKRI0+yta+G5Q=";

  nativeBuildInputs = [ installShellFiles ];

  CGO_ENABLED = 0;

  # Some lint checks fail
  doCheck = false;

  ldflags = [
    "-s"
    "-X github.com/civo/cli/common.VersionCli=${version}"
    "-X github.com/civo/cli/common.CommitCli=${src.rev}"
    "-X github.com/civo/cli/common.DateCli=unknown"
  ];

  doInstallCheck = false;

  postInstall = ''
    mv $out/bin/cli $out/bin/civo
    installShellCompletion --cmd civo \
      --bash <($out/bin/civo completion bash) \
      --fish <($out/bin/civo completion fish) \
      --zsh <($out/bin/civo completion zsh)
  '';

  meta = with lib; {
    description = "CLI for interacting with Civo resources";
    mainProgram = "civo";
    homepage = "https://github.com/civo/cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ berryp ];
  };
}
