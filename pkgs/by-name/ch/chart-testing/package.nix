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

buildGoModule (finalAttrs: {
  pname = "chart-testing";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "chart-testing";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vVF//TfhAep+lUvh1pQRlIBP9/7KTERiHVQyE/hr23M=";
  };

  vendorHash = "sha256-uy5a3kBiMro8SgFgmamXYyjiySgnebwx/R+3UOqEcr8=";

  postPatch = ''
    substituteInPlace pkg/config/config.go \
      --replace "\"/etc/ct\"," "\"$out/etc/ct\","
  '';

  ldflags = [
    "-w"
    "-s"
    "-X github.com/helm/chart-testing/v3/ct/cmd.Version=${finalAttrs.version}"
    "-X github.com/helm/chart-testing/v3/ct/cmd.GitCommit=${finalAttrs.src.rev}"
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

  meta = {
    description = "Tool for testing Helm charts";
    homepage = "https://github.com/helm/chart-testing";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ atkinschang ];
    mainProgram = "ct";
  };
})
