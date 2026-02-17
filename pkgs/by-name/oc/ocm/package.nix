{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  ocm,
}:

buildGoModule (finalAttrs: {
  pname = "ocm";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "openshift-online";
    repo = "ocm-cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-nyfuXgpgQEpiXRIpAxFiNG+ANChwunl19qeibZIse10=";
  };

  vendorHash = "sha256-4GwmUURR0yUAbTJc6v66JiqmvcDEPs6pVgOzuho//Lk=";

  # Strip the final binary.
  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # Tests expect the binary to be located in the root directory.
  preCheck = ''
    ln -s $GOPATH/bin/ocm ocm
  '';

  checkFlags = [
    # Disable integration tests which require networking and gnupg which has issues in the sandbox
    "-skip=^TestCLI$"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ocm \
      --bash <($out/bin/ocm completion bash) \
      --fish <($out/bin/ocm completion fish) \
      --zsh <($out/bin/ocm completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = ocm;
    command = "ocm version";
  };

  meta = {
    description = "CLI for the Red Hat OpenShift Cluster Manager";
    mainProgram = "ocm";
    license = lib.licenses.asl20;
    homepage = "https://github.com/openshift-online/ocm-cli";
    maintainers = with lib.maintainers; [
      stehessel
      jfchevrette
    ];
  };
})
