{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "cmctl";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "cert-manager";
    repo = "cert-manager";
    rev = "e3a2a803e8ed7f8a88d5f535d6e9a061c1571194";
    sha256 = "0484dh520plgmrv39lbih44z1dz0r3sf115kqvcpfmg13b0328d0";
  };

  vendorSha256 = "sha256-tKvvqYGwLEoSfGzBRLx8xC/0Kz1uLmHYQ+gcHOW+550=";

  subPackages = [ "cmd/ctl" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build.name=cmctl"
    "-X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build/commands.registerCompletion=true"
    "-X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v${version}"
    "-X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=${src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/ctl $out/bin/cmctl
    installShellCompletion --cmd cmctl \
      --bash <($out/bin/cmctl completion bash) \
      --fish <($out/bin/cmctl completion fish) \
      --zsh <($out/bin/cmctl completion zsh)
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A CLI tool for managing cert-manager service on Kubernetes clusters";
    longDescription = ''
      cert-manager adds certificates and certificate issuers as resource types
      in Kubernetes clusters, and simplifies the process of obtaining, renewing
      and using those certificates.

      It can issue certificates from a variety of supported sources, including
      Let's Encrypt, HashiCorp Vault, and Venafi as well as private PKI, and it
      ensures certificates remain valid and up to date, attempting to renew
      certificates at an appropriate time before expiry.
    '';
    downloadPage = "https://github.com/cert-manager/cert-manager";
    license = licenses.asl20;
    homepage = "https://cert-manager.io/";
    maintainers = with maintainers; [ joshvanl ];
  };
}
