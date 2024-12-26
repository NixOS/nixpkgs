{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "civo";
  version = "1.1.92";

  src = fetchFromGitHub {
    owner = "civo";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-nsH/6OVvCOU4f9UZNFOm9AtyN9L4tXB285580g3SsxE=";
  };

  vendorHash = "sha256-G3ijLi3ZbURVHkjUwylFWwxRyxroppVUFJveKw5qLq8=";

  nativeBuildInputs = [ installShellFiles ];

  env.CGO_ENABLED = 0;

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
    maintainers = with maintainers; [ techknowlogick ];
  };
}
