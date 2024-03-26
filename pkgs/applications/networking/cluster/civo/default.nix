{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "civo";
  version = "1.0.77";

  src = fetchFromGitHub {
    owner  = "civo";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "sha256-W9CJAFLGarDG/Y8g2Whoh4v9hxqb8txuLfAkooW8PNM=";
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
