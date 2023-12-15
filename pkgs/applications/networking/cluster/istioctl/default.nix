{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "istioctl";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "istio";
    repo = "istio";
    rev = version;
    hash = "sha256-V07e0IbHlQLSVxzWClHX8PrwKY4DaMZmwy3IwGTD7jI=";
  };
  vendorHash = "sha256-PQYlqi4KDietVV2J5KiaoFqHg12l0bomj57lsTYkSPo=";

  nativeBuildInputs = [ installShellFiles ];

  # Bundle release metadata
  ldflags = let
    attrs = [
      "istio.io/istio/pkg/version.buildVersion=${version}"
      "istio.io/istio/pkg/version.buildStatus=Nix"
      "istio.io/istio/pkg/version.buildTag=${version}"
      "istio.io/istio/pkg/version.buildHub=docker.io/istio"
    ];
  in ["-s" "-w" "${lib.concatMapStringsSep " " (attr: "-X ${attr}") attrs}"];

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

  meta = with lib; {
    description = "Istio configuration command line utility for service operators to debug and diagnose their Istio mesh";
    homepage = "https://istio.io/latest/docs/reference/commands/istioctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ bryanasdev000 veehaitch ];
  };
}
