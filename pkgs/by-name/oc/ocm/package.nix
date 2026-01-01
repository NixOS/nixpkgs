{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  ocm,
}:

buildGoModule rec {
  pname = "ocm";
<<<<<<< HEAD
  version = "1.0.10";
=======
  version = "1.0.9";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "openshift-online";
    repo = "ocm-cli";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-tY7THl1mv9XTL6KVO1/lvZpcNimk3M8pmCbXoH0oet0=";
=======
    sha256 = "sha256-hj91qHj88YW0vKhwhuDZB91u63sJ3VrxfcJwbxgIzWg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-GOdRYVnFPS1ovFmU+9MEnwTNg1sa9/25AjzbcbBJrQ0=";

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

<<<<<<< HEAD
  meta = {
    description = "CLI for the Red Hat OpenShift Cluster Manager";
    mainProgram = "ocm";
    license = lib.licenses.asl20;
    homepage = "https://github.com/openshift-online/ocm-cli";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "CLI for the Red Hat OpenShift Cluster Manager";
    mainProgram = "ocm";
    license = licenses.asl20;
    homepage = "https://github.com/openshift-online/ocm-cli";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      stehessel
      jfchevrette
    ];
  };
}
