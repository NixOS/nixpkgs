{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "civo";
  version = "1.0.60";

  src = fetchFromGitHub {
    owner  = "civo";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "sha256-f6r82rZ5PMjBLdeuz1vbyWuCMy73NAYt4+0w7fICTQ0=";
  };

  vendorHash = "sha256-ER7QcDlts/Dt8FimDu87IE3hihMRNGHpyuvAXRI3QR8=";

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
    homepage = "https://github.com/civo/cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ berryp ];
  };
}
