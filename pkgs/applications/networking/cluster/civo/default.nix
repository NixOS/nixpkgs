{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "civo";
  version = "1.0.76";

  src = fetchFromGitHub {
    owner  = "civo";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "sha256-Bk0YfW9KDliaJIqpVxCXTy7EiGGJPZTXcn6SFEmywRE=";
  };

  vendorHash = "sha256-22n+ks1D65Gk2acCMHxgj19VHDf4B23ivqHfo3J45j0=";

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
