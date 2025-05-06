{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule rec {
  pname = "cmctl";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "cert-manager";
    repo = "cmctl";
    rev = "v${version}";
    hash = "sha256-Kr7vwVW6v08QRbJDs2u0vK241ljNfhLVYIQCBl31QSs=";
  };

  vendorHash = "sha256-D83Ufpa7PLQWBCHX5d51me3aYprGzc9RoKVma2Ax1Is=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v${version}"
    "-X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=${src.rev}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  checkPhase = ''
    go test --race $(go list ./... | grep -v /test/)
  '';

  # Trusted by this computer: no: x509: “cert-manager” certificate is not
  # trusted
  doCheck = !stdenv.hostPlatform.isDarwin;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cmctl \
        --bash <($out/bin/cmctl completion bash) \
        --fish <($out/bin/cmctl completion fish) \
        --zsh <($out/bin/cmctl completion zsh)
  '';

  meta = with lib; {
    description = "Command line utility to interact with a cert-manager instalation on Kubernetes";
    mainProgram = "cmctl";
    longDescription = ''
      cert-manager adds certificates and certificate issuers as resource types
      in Kubernetes clusters, and simplifies the process of obtaining, renewing
      and using those certificates.

      It can issue certificates from a variety of supported sources, including
      Let's Encrypt, HashiCorp Vault, and Venafi as well as private PKI, and it
      ensures certificates remain valid and up to date, attempting to renew
      certificates at an appropriate time before expiry.

      cmctl is a command line tool to help you manage cert-manager and its
      resources inside your Kubernetes cluster.
    '';
    downloadPage = "https://github.com/cert-manager/cmctl";
    license = licenses.asl20;
    homepage = "https://cert-manager.io/";
    maintainers = with maintainers; [ joshvanl ];
  };
}
