{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "istioctl";
  version = "1.30.1";

  src = fetchFromGitHub {
    owner = "istio";
    repo = "istio";
    rev = finalAttrs.version;
    hash = "sha256-jW0L/86D0YgAoUYAZfwHMGes5x0P5QLelP79XuG3riU=";
  };
  vendorHash = "sha256-dOPrYZxOeP1ZahSaPS6U6tJDbTx/5BbwHFcNKS+2Lqc=";

  nativeBuildInputs = [ installShellFiles ];

  # Bundle release metadata
  ldflags =
    let
      attrs = [
        "istio.io/istio/pkg/version.buildVersion=${finalAttrs.version}"
        "istio.io/istio/pkg/version.buildStatus=Nix"
        "istio.io/istio/pkg/version.buildTag=${finalAttrs.version}"
        "istio.io/istio/pkg/version.buildHub=docker.io/istio"
      ];
    in
    [
      "-s"
      "-w"
    ]
    ++ map (attr: "-X ${attr}") attrs;

  subPackages = [ "istioctl/cmd/istioctl" ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/istioctl version --remote=false | grep ${finalAttrs.version} > /dev/null
  '';

  postInstall = ''
    $out/bin/istioctl collateral --man --bash --zsh
    installManPage *.1
    installShellCompletion istioctl.bash
    installShellCompletion --zsh _istioctl
  '';

  meta = {
    description = "Istio configuration command line utility for service operators to debug and diagnose their Istio mesh";
    mainProgram = "istioctl";
    homepage = "https://istio.io/latest/docs/reference/commands/istioctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      veehaitch
      ryan4yin
    ];
  };
})
