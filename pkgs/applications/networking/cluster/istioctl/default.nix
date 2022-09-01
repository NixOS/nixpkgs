{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "istioctl";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "istio";
    repo = "istio";
    rev = version;
    sha256 = "sha256-exLLmrHHXAp/S7z4JwIr8umwxZkmV6/kp/4fd8ODh1I=";
  };
  vendorSha256 = "sha256-A0Haf18ot3WckibSmZe5INjMr7zTrMB6xqqnqpUKV34=";

  nativeBuildInputs = [ installShellFiles ];

  # Bundle release metadata
  ldflags = let
    attrs = [
      "istio.io/pkg/version.buildVersion=${version}"
      "istio.io/pkg/version.buildStatus=Nix"
      "istio.io/pkg/version.buildTag=${version}"
      "istio.io/pkg/version.buildHub=docker.io/istio"
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
    maintainers = with maintainers; [ superherointj bryanasdev000 veehaitch ];
    platforms = platforms.unix;
  };
}
