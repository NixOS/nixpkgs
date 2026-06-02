{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "diffyml";
  version = "1.6.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "szhekpisov";
    repo = "diffyml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kv1+bC4oyjKXfbC6cS9OPyByqp4kELta43JZ0sGMyjM=";
  };

  vendorHash = "sha256-QE/EwVzMqUO24ZAl0WBibGx6x0kNo1AUTZtfnQvX50k=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.buildDate=1970-01-01T00:00:00Z"
  ];

  excludedPackages = [
    "bench"
    "doc/gen-cli-ref"
  ];

  checkFlags =
    let
      # Skip tests that tries to do module lookup
      skippedTests = [
        "TestProperty3_GoModuleValidity"
        "TestProperty5_DependencyIntegrity_BuildWithVerify"
        "TestProperty5_DependencyIntegrity"
        "TestProperty5_DependencyIntegrity_WithGoModCheck"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Structural YAML diff tool with Kubernetes support";
    homepage = "https://szhekpisov.github.io/diffyml";
    downloadPage = "https://github.com/szhekpisov/diffyml";
    changelog = "https://github.com/szhekpisov/diffyml/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "diffyml";
  };
})
