{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "istioctl";
  version = "1.11.5";

  src = fetchFromGitHub {
    owner = "istio";
    repo = "istio";
    rev = version;
    sha256 = "sha256-GngjZnE6G/7Iz/BFUKciZAnk/FjcSngt9H+M23E3hHk=";
  };
  vendorSha256 = "sha256-MzlDChyuEVfcfS0DLf/FqKXk3qzsqwO3ZBVJlZqrNhg=";

  doCheck = false;

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
    maintainers = with maintainers; [ veehaitch ];
    platforms = platforms.unix;
  };
}
