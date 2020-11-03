{ lib, buildGoModule, fetchFromGitHub, go-bindata, installShellFiles }:

buildGoModule rec {
  pname = "istioctl";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "istio";
    repo = "istio";
    rev = version;
    sha256 = "1vy6y6gk7ljnrb7cxxaa60i4ycylsrd2yszbly1aaz5vnh1vsfz9";
  };
  vendorSha256 = "0f2n8mwnj9i4qifs0f63jrgr61mjs3c1arxnny723i5pialj3zdl";

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
