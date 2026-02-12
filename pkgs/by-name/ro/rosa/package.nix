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

buildGoModule (finalAttrs: {
  pname = "rosa";
  version = "1.2.60";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "rosa";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VKaoN91kxfGp9rFmO6VyD4WwmppITirenF1qpASDbDI=";
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
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ "TestCache" ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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

  meta = {
    description = "CLI for the Red Hat OpenShift Service on AWS";
    license = lib.licenses.asl20;
    homepage = "https://github.com/openshift/rosa";
    maintainers = with lib.maintainers; [ jfchevrette ];
  };
})
