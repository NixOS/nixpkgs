{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "istioctl";
<<<<<<< HEAD
  version = "1.28.2";
=======
  version = "1.28.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "istio";
    repo = "istio";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-T3bhFAIsdnobcTYc80jY7mtIKRjBK6OcqGR59ko6q3s=";
  };
  vendorHash = "sha256-QcPtQV3sO+B2NtxJvOi5x5hlAI1ace4LqWO84fAovGw=";
=======
    hash = "sha256-NLARp5Gw04UosyLw3TkEmtvSLKa+tYp4s60UKvcJOgw=";
  };
  vendorHash = "sha256-ge9aR3ZYOJaYp0D1UWzzg40nXlwM/Sl1Ep+u1CmdSV8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];

  # Bundle release metadata
  ldflags =
    let
      attrs = [
        "istio.io/istio/pkg/version.buildVersion=${version}"
        "istio.io/istio/pkg/version.buildStatus=Nix"
        "istio.io/istio/pkg/version.buildTag=${version}"
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
    $out/bin/istioctl version --remote=false | grep ${version} > /dev/null
  '';

  postInstall = ''
    $out/bin/istioctl collateral --man --bash --zsh
    installManPage *.1
    installShellCompletion istioctl.bash
    installShellCompletion --zsh _istioctl
  '';

<<<<<<< HEAD
  meta = {
    description = "Istio configuration command line utility for service operators to debug and diagnose their Istio mesh";
    mainProgram = "istioctl";
    homepage = "https://istio.io/latest/docs/reference/commands/istioctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Istio configuration command line utility for service operators to debug and diagnose their Istio mesh";
    mainProgram = "istioctl";
    homepage = "https://istio.io/latest/docs/reference/commands/istioctl";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      veehaitch
      ryan4yin
    ];
  };
}
