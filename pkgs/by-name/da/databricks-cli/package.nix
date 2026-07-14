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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-08fYKWJRYkT48ivM9miPyoQ3fNNm6etdeqvqPZehtaM=";
  };

  # Otherwise these tests fail asserting that the version is 0.0.0-dev
  postPatch = ''
    substituteInPlace bundle/deploy/terraform/init_test.go \
      --replace-fail "cli/0.0.0-dev" "cli/${finalAttrs.version}"
  '';

  vendorHash = "sha256-1K722pdIXdYkc2HMlnjyjrZb/L2iUoRx2vY1szcF7aY=";

  subPackages = [ "." ];

  ldflags = [
    "-X github.com/databricks/cli/internal/build.buildVersion=${finalAttrs.version}"
    "-X github.com/databricks/cli/internal/build.buildTag=v${finalAttrs.version}"
    "-X github.com/databricks/cli/internal/build.buildSummary=v${finalAttrs.version}"
    "-X github.com/databricks/cli/internal/build.buildMajor=${lib.versions.major finalAttrs.version}"
    "-X github.com/databricks/cli/internal/build.buildMinor=${lib.versions.minor finalAttrs.version}"
    "-X github.com/databricks/cli/internal/build.buildPatch=${lib.versions.patch finalAttrs.version}"
    "-X github.com/databricks/cli/internal/build.buildIsSnapshot=false"
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
      "TestExpandGlobPathsInPipelines"
      "TestRelativePathTranslationDefault"
      "TestRelativePathTranslationOverride"
      "TestWorkspaceVerifyProfileForHost"
      "TestWorkspaceVerifyProfileForHost/default_config_file_with_match"
      "TestWorkspaceResolveProfileFromHost"
      "TestWorkspaceResolveProfileFromHost/no_config_file"
      "TestWorkspaceClientNormalizesHostBeforeProfileResolution"
      "TestClearWorkspaceClient"
      "TestValidateFolderPermissions"
      "TestFilesToSync"
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
