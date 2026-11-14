{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:
buildGo126Module (finalAttrs: {
  pname = "octl";
  version = "0.0.31";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "octl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZXsQkbaKm2YQwDj3AeAez2UjwrlNSJoudBeSftI0maE=";
  };

  vendorHash = "sha256-Drmdk3s41UXd09s7EQr+5L1mZwwzhbPwBaGcNsqMDFI=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/outscale/octl/pkg/version.Version=v${finalAttrs.version}"
    "-X=k8s.io/component-base/version.gitVersion=v1.36.2+octl"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  checkFlags =
    let
      # Tests that either network connection and/or OUTSCALE credentials
      skipedTests = [
        "TestIAASAPI"
        "TestIAASAliases"
        "TestIAASCRUD"
        "TestBase64File"
        "TestPolicyFile"
        "TestPolicyString"
        "TestIAASPipe"
        "TestWaitFor"
        "TestReadCatalog"
        "TestReadConsumption"
        "TestReadConsumptionAggregate"
        "TestFilterNullValues"
        "TestReverse"
        "TestVolumeByDeviceName"
        "TestSecurityGroupRules"
        "TestKube"
        "TestMetadata"
        "TestProfilePriority"
        "TestStorageCRUD"
        "TestObjectDownload"
        "TestBucketVersioning"
        "TestBucketEncryption"
        "TestBucketCORS"
        "TestBucketPolicy"
        "TestBucketWebsite"
        "TestBucketLifecycle"
        "TestBucketACL"
        "TestObjectACL"
        "TestObjectTagging"
        "TestPresign"
        "TestUpdateRealReleaseMutation"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skipedTests}$" ];

  postInstall = ''
    wrapProgram $out/bin/octl \
      --add-flags "--no-upgrade"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd octl \
      --bash <($out/bin/octl completion bash) \
      --fish <($out/bin/octl completion fish) \
      --zsh <($out/bin/octl completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern CLI for Outscale";
    homepage = "https://github.com/outscale/octl";
    changelog = "https://github.com/outscale/octl/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jobs62 ];
    mainProgram = "octl";
  };
})
