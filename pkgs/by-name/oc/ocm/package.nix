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
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "openshift-online";
    repo = "ocm-cli";
    rev = "v${version}";
    sha256 = "sha256-RuGUIG58cyyWvHD/0T7xwtzFy9XJUmavkQg4MRAHQqQ=";
  };

  vendorHash = "sha256-qkTh+tkU6MXBJkX0XwktRCMjoySe1/9uWHFGTc7ozRM=";

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
