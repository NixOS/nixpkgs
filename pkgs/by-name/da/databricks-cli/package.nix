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
  version = "1.20.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RFtDUvoJskKikLQyunVo5DN0Hr5s/hlKjgl8Y+c2W48=";
  };

  vendorHash = "sha256-moXbF1k1zg5DwVxysaK0ULYx7Ldh4V7SBt9PXI4NAdk=";

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
