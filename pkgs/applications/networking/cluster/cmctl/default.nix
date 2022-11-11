{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "cmctl";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "cert-manager";
    repo = "cert-manager";
    rev = "da3265115bfd8be5780801cc6105fa857ef71965";
    sha256 = "0s6nki61crx62v6ypmm0yjbyy71ygifffhkp5554jh4g9hvcfbmr";
  };

  vendorSha256 = "sha256-WPFteR3t9qQiuBcCLqvp8GterqcD2SxJi59Wb7BvDT4=";

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
