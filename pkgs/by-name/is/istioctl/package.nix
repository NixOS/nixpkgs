{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "istioctl";
  version = "1.28.3";

  src = fetchFromGitHub {
    owner = "istio";
    repo = "istio";
    rev = finalAttrs.version;
    hash = "sha256-V8yG0Dj2/KevTiG9C68SlkLzo5xkblxMYhsZOq1ucgc=";
  };
  vendorHash = "sha256-QcPtQV3sO+B2NtxJvOi5x5hlAI1ace4LqWO84fAovGw=";

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
