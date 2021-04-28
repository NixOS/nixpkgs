{ lib, buildGoModule, fetchFromGitHub, go-bindata, installShellFiles }:

buildGoModule rec {
  pname = "istioctl";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "istio";
    repo = "istio";
    rev = version;
    sha256 = "sha256-gCI4LRUjsE6V7fomWaQsseX1Xi2f+2ZgtvWBDarpXvw=";
  };
  vendorSha256 = "sha256-yJHYyRPl1V1WNV0nJoR3bRTTGRTQaT/tG4TSQeL5U88=";

  doCheck = false;

  nativeBuildInputs = [ go-bindata installShellFiles ];

  # Bundle charts
  preBuild = ''
    patchShebangs operator/scripts
    operator/scripts/create_assets_gen.sh
  '';

  # Bundle release metadata
  buildFlagsArray = let
    attrs = [
      "istio.io/pkg/version.buildVersion=${version}"
      "istio.io/pkg/version.buildStatus=Nix"
      "istio.io/pkg/version.buildTag=${version}"
      "istio.io/pkg/version.buildHub=docker.io/istio"
    ];
  in ["-ldflags=-s -w ${lib.concatMapStringsSep " " (attr: "-X ${attr}") attrs}"];

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
