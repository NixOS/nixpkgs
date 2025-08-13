{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  ocm,
}:

buildGoModule rec {
  pname = "ocm";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "openshift-online";
    repo = "ocm-cli";
    rev = "v${version}";
    sha256 = "sha256-fN7nrWxF4eFaEd5iNpVJWoK23S76jjh20834b/MVlPo=";
  };

  vendorHash = "sha256-q/Se4jq1a25QX9TzVkPbOi7AeT2hossCX4dh9gMqCx0=";

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

  postInstall = ''
    installShellCompletion --cmd ocm \
      --bash <($out/bin/ocm completion bash) \
      --fish <($out/bin/ocm completion fish) \
      --zsh <($out/bin/ocm completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = ocm;
    command = "ocm version";
  };

  meta = with lib; {
    description = "CLI for the Red Hat OpenShift Cluster Manager";
    mainProgram = "ocm";
    license = licenses.asl20;
    homepage = "https://github.com/openshift-online/ocm-cli";
    maintainers = with maintainers; [
      stehessel
      jfchevrette
    ];
  };
}
