{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  python3,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "databricks-cli";
  version = "0.288.0";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GBkeIY/uYiLA6CmKiMnMuGX2sPSyOmr9gZXZTe/AoQs=";
  };

  # Otherwise these tests fail asserting that the version is 0.0.0-dev
  postPatch = ''
    substituteInPlace bundle/deploy/terraform/init_test.go \
      --replace-fail "cli/0.0.0-dev" "cli/${finalAttrs.version}"
  '';

  vendorHash = "sha256-YtXdGQzuzTHBrqRUk2ORacVNixdLt+jHxJ8zMxwlcmI=";

  excludedPackages = [
    "bundle/internal"
    "acceptance"
    "integration"
    "tools/testrunner"
    "tools/testmask"
  ];

  ldflags = [
    "-X github.com/databricks/cli/internal/build.buildVersion=${finalAttrs.version}"
  ];

  postBuild = ''
    mv "$GOPATH/bin/cli" "$GOPATH/bin/databricks"
  '';

  checkFlags =
    "-skip="
    + (lib.concatStringsSep "|" [
      # Need network
      "TestConsistentDatabricksSdkVersion"
      "TestTerraformArchiveChecksums"
      "TestExpandPipelineGlobPaths"
      "TestRelativePathTranslationDefault"
      "TestRelativePathTranslationOverride"
      "TestWorkspaceVerifyProfileForHost"
      "TestWorkspaceVerifyProfileForHost/default_config_file_with_match"
      "TestWorkspaceResolveProfileFromHost"
      "TestWorkspaceResolveProfileFromHost/no_config_file"
      "TestBundleConfigureDefault"
      # Use uv venv which doesn't work with nix
      # https://github.com/astral-sh/uv/issues/4450
      "TestVenvSuccess"
      "TestPatchWheel"
      # Requires HOME to be set
      "TestCacheDirEnvVar"
    ]);

  nativeCheckInputs = [
    gitMinimal
    (python3.withPackages (
      ps: with ps; [
        setuptools
        wheel
      ]
    ))
  ];

  preCheck = ''
    # Some tested depends on git and remote url
    git init
    git remote add origin https://github.com/databricks/cli.git
  '';

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/databricks";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Databricks CLI";
    mainProgram = "databricks";
    homepage = "https://github.com/databricks/cli";
    changelog = "https://github.com/databricks/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.databricks;
    maintainers = with lib.maintainers; [
      kfollesdal
      taranarmo
    ];
  };
})
