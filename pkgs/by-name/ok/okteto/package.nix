{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "okteto";
  version = "3.18.0";

  src = fetchFromGitHub {
    owner = "okteto";
    repo = "okteto";
    tag = finalAttrs.version;
    hash = "sha256-s3p4JpMivznfUPBA0R+IPVtrOgwSAPsaXJKtYOpXNOk=";
  };

  vendorHash = "sha256-ZZm9vaVS8kkrVo5NViQd5UpBm+XseNuN81F13D+UL1k=";

  postPatch = ''
    # Disable some tests that need file system & network access.
    find cmd -name "*_test.go" | xargs rm -f
    rm -f pkg/analytics/track_test.go
  '';

  nativeBuildInputs = [ installShellFiles ];

  excludedPackages = [
    "integration"
    "samples"
    "tools"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/okteto/okteto/pkg/config.VersionString=${finalAttrs.version}"
  ];

  tags = [
    "osusergo"
    "netgo"
    "static_build"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkFlags =
    let
      skippedTests = [
        # require network access
        "TestCreateDockerfile"

        # access file system
        "Test_translateDeployment"
        "Test_translateStatefulSet"
        "Test_translateJobWithoutVolumes"
        "Test_translateJobWithVolumes"
        "Test_translateService"
        "TestProtobufTranslator_Translate_Success"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd okteto \
      --bash <($out/bin/okteto completion bash) \
      --fish <($out/bin/okteto completion fish) \
      --zsh <($out/bin/okteto completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "HOME=\"$(mktemp -d)\" okteto version";
  };

  meta = {
    description = "Develop your applications directly in your Kubernetes Cluster";
    homepage = "https://okteto.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "okteto";
  };
})
