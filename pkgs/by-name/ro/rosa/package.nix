{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  rosa,
  nix-update-script,
}:

buildGoModule rec {
  pname = "rosa";
  version = "1.2.49";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "rosa";
    rev = "v${version}";
    hash = "sha256-x1P9Z0TpKw90/eLJHMcoO7niqSM3F+iFVKKTcJAstng=";
  };
  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  __darwinAllowLocalNetworking = true;

  # skip e2e tests package
  excludedPackages = [ "tests/e2e" ];

  # skip tests that require network access
  checkFlags =
    let
      skippedTests = [
        "TestCluster"
        "TestRhRegionCommand"
      ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "TestCache" ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd rosa \
      --bash <($out/bin/rosa completion bash) \
      --fish <($out/bin/rosa completion fish) \
      --zsh <($out/bin/rosa completion zsh)
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = rosa;
      command = "rosa version --client";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "CLI for the Red Hat OpenShift Service on AWS";
    license = licenses.asl20;
    homepage = "https://github.com/openshift/rosa";
    maintainers = with maintainers; [ jfchevrette ];
  };
}
