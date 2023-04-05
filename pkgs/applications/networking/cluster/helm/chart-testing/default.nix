{ buildGoModule
, coreutils
, fetchFromGitHub
, git
, installShellFiles
, kubectl
, kubernetes-helm
, lib
, makeWrapper
, yamale
, yamllint
}:

buildGoModule rec {
  pname = "chart-testing";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "helm";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ccP3t+Q4aZviYw8by2JDiuKHt7o6EKFxBxlhEntmV5A=";
  };

  vendorHash = "sha256-4x/8uDCfrERC+ww+iyP+dHIQ820IOARXj60KnjqeDkM=";

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

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  postInstall = ''
    install -Dm644 -t $out/etc/ct etc/chart_schema.yaml
    install -Dm644 -t $out/etc/ct etc/lintconf.yaml

    installShellCompletion --cmd ct \
      --bash <($out/bin/ct completion bash) \
      --zsh <($out/bin/ct completion zsh) \
      --fish <($out/bin/ct completion fish) \

    wrapProgram $out/bin/ct --prefix PATH : ${lib.makeBinPath [
      coreutils
      git
      kubectl
      kubernetes-helm
      yamale
      yamllint
    ]}
  '';

  meta = with lib; {
    description = "A tool for testing Helm charts";
    homepage = "https://github.com/helm/chart-testing";
    license = licenses.asl20;
    maintainers = with maintainers; [ atkinschang ];
    mainProgram = "ct";
  };
}
