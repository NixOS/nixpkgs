{
  buildGoModule,
  coreutils,
  fetchFromGitHub,
  git,
  installShellFiles,
  kubectl,
  kubernetes-helm,
  lib,
  makeWrapper,
  yamale,
  yamllint,
}:

buildGoModule rec {
  pname = "chart-testing";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "chart-testing";
    rev = "v${version}";
    hash = "sha256-59a86yR/TDAWGCsj3pbDjXJGMvyHYnjsnxzjWr61PuU=";
  };

  vendorHash = "sha256-aVXISRthJxxvtrfC0DpewLHCiJPh4tO+SKl3Q9uP14k=";

  postPatch = ''
    substituteInPlace pkg/config/config.go \
      --replace "\"/etc/ct\"," "\"$out/etc/ct\","
  '';

  ldflags = [
    "-w"
    "-s"
    "-X github.com/helm/chart-testing/v3/ct/cmd.Version=${version}"
    "-X github.com/helm/chart-testing/v3/ct/cmd.GitCommit=${src.rev}"
    "-X github.com/helm/chart-testing/v3/ct/cmd.BuildDate=19700101-00:00:00"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    install -Dm644 -t $out/etc/ct etc/chart_schema.yaml
    install -Dm644 -t $out/etc/ct etc/lintconf.yaml

    installShellCompletion --cmd ct \
      --bash <($out/bin/ct completion bash) \
      --zsh <($out/bin/ct completion zsh) \
      --fish <($out/bin/ct completion fish) \

    wrapProgram $out/bin/ct --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        git
        kubectl
        kubernetes-helm
        yamale
        yamllint
      ]
    }
  '';

  meta = with lib; {
    description = "Tool for testing Helm charts";
    homepage = "https://github.com/helm/chart-testing";
    license = licenses.asl20;
    maintainers = with maintainers; [ atkinschang ];
    mainProgram = "ct";
  };
}
