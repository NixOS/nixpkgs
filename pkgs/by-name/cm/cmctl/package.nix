{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "cmctl";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "cert-manager";
    repo = "cmctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yX3A63MU1PaFQmAemp62F5sHlgWpkInhbIIZx7HfdEc=";
  };

  vendorHash = "sha256-LDmhlSWa6/Z4KyXnF9OFVkgTksV7TL+m1os0NW89ZpY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v${finalAttrs.version}"
    "-X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=${finalAttrs.src.rev}"
  ];

  # integration tests require running etcd, kubernetes
  postPatch = ''
    rm -r test/integration
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  # Trusted by this computer: no: x509: “cert-manager” certificate is not
  # trusted
  doCheck = !stdenv.hostPlatform.isDarwin;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cmctl \
        --bash <($out/bin/cmctl completion bash) \
        --fish <($out/bin/cmctl completion fish) \
        --zsh <($out/bin/cmctl completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
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
    license = lib.licenses.asl20;
    homepage = "https://cert-manager.io/";
    maintainers = with lib.maintainers; [ joshvanl ];
  };
})
