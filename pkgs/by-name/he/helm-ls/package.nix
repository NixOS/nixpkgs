{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, helm-ls
}:

buildGoModule rec {
  pname = "helm-ls";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mrjosh";
    repo = "helm-ls";
    rev = "v${version}";
    hash = "sha256-EuZbbeRssacrctIbxBbd2GOh8zgFi2OBRregfC88se0=";
  };

  vendorHash = "sha256-AWKCE2BZGVYcr6Pe8URQo11Xnr3sfgWWkm9v7vvILOo=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/helm-ls $out/bin/helm_ls
    installShellCompletion --cmd helm_ls \
      --bash <($out/bin/helm_ls completion bash) \
      --fish <($out/bin/helm_ls completion fish) \
      --zsh <($out/bin/helm_ls completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = helm-ls;
    command = "helm_ls version";
  };

  meta = with lib; {
    description = "Language server for Helm";
    changelog = "https://github.com/mrjosh/helm-ls/releases/tag/v${version}";
    homepage = "https://github.com/mrjosh/helm-ls";
    license = licenses.mit;
    maintainers = with maintainers; [ stehessel ];
    mainProgram = "helm_ls";
  };
}
