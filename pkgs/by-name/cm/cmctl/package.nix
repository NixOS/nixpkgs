{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, nix-update-script
}:

buildGoModule rec {
  pname = "cmctl";
  version = "1.14.7";

  src = fetchFromGitHub {
    owner = "cert-manager";
    repo = "cert-manager";
    rev = "v${version}";
    hash = "sha256-ZvrR8k1jiyAMUKM9VA6vKH2uhMKnd22OQe08CIlxXjs=";
  };

  sourceRoot = "${src.name}/cmd/ctl";

  vendorHash = "sha256-qaSzAPNVe25Fbbfqy0OFFnMJ21IlWuoJKwnT7y2wmOs=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build.name=cmctl"
    "-X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build/commands.registerCompletion=true"
    "-X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v${version}"
    "-X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=${src.rev}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  # Trusted by this computer: no: x509: “cert-manager” certificate is not trusted
  doCheck = !stdenv.hostPlatform.isDarwin;

  postInstall = ''
    mv $out/bin/ctl $out/bin/cmctl
  '' + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cmctl \
      --bash <($out/bin/cmctl completion bash) \
      --fish <($out/bin/cmctl completion fish) \
      --zsh <($out/bin/cmctl completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "CLI tool for managing cert-manager service on Kubernetes clusters";
    mainProgram = "cmctl";
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
