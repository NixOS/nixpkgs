{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  git,
  buildPackages,
  # passthru
  callPackage,
  testers,
  pulumi,
  pulumiPackages,
  python3Packages,
  nix-update-script,
  _experimental-update-script-combinators,
}:
buildGoModule rec {
  pname = "pulumi";
  version = "3.162.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi";
    tag = "v${version}";
    hash = "sha256-avtqURmj3PL82j89kLmVsBWqJJHnOFqR1huoUESt4L4=";
    # Some tests rely on checkout directory name
    name = "pulumi";
  };

  vendorHash = "sha256-fJFpwhbRkxSI2iQfNJ9qdL9oYM1SVVMJ30VIymoZBmg=";

  sourceRoot = "${src.name}/pkg";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  # https://github.com/pulumi/pulumi/blob/3ec1aa75d5bf7103b283f46297321a9a4b1a8a33/.goreleaser.yml#L20-L26
  tags = [ "osusergo" ];
  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=v${version}"
  ];

  excludedPackages = [
    "util/generate"
    "codegen/gen_program_test"
  ];

  # Required for user.Current implementation with osusergo on Darwin.
  preCheck = ''
    export HOME=$TMPDIR USER=nixbld
  '';

  checkFlags = [
    # The tests require `version.Version` (i.e. ldflags) to be unset.
    "-ldflags="
    # Skip tests that fail in Nix sandbox.
    "-skip=^${
      lib.concatStringsSep "$|^" [
        # Concurrent map modification in test case.
        # TODO: remove after the fix is merged and released.
        # https://github.com/pulumi/pulumi/pull/19200
        "TestGetDocLinkForPulumiType"

        # Seems to require TTY.
        "TestProgressEvents"

        # Tries to clone repo: https://github.com/pulumi/test-repo.git
        "TestValidateRelativeDirectory"
        "TestRepoLookup"
        "TestDSConfigureGit"

        # Tries to clone repo: github.com/pulumi/templates.git
        "TestGenerateOnlyProjectCheck"
        "TestPulumiNewSetsTemplateTag"
        "TestPulumiPromptRuntimeOptions"
        "TestPulumiNewOrgTemplate"
        "TestPulumiNewWithOrgTemplates"
        "TestPulumiNewWithoutPulumiAccessToken"
        "TestPulumiNewWithoutTemplateSupport"

        # Connects to https://pulumi-testing.vault.azure.net/…
        "TestAzureCloudManager"
        "TestAzureKeyEditProjectStack"
        "TestAzureKeyVaultAutoFix15329"
        "TestAzureKeyVaultExistingKey"
        "TestAzureKeyVaultExistingKeyState"
        "TestAzureKeyVaultExistingState"

        # Requires pulumi-yaml
        "TestProjectNameDefaults"
        "TestProjectNameOverrides"

        # Downloads pulumi-resource-random from Pulumi plugin registry.
        "TestPluginInstallCancellation"

        # Requires language-specific tooling and/or Internet access.
        "TestGenerateProgram"
        "TestGenerateProgramVersionSelection"
        "TestGeneratePackage"
        "TestGeneratePackageOne"
        "TestGeneratePackageThree"
        "TestGeneratePackageTwo"
        "TestParseAndRenderDocs"
        "TestImportResourceRef"
      ]
    }$"
  ];

  # Allow tests that bind or connect to localhost on macOS.
  __darwinAllowLocalNetworking = true;

  # Use pulumi from the previous stage if we can’t execute compiled binary.
  pulumiExe =
    if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
      "${placeholder "out"}/bin/pulumi"
    else
      "${buildPackages.pulumi}/bin/pulumi";

  postInstall = ''
    for shell in bash fish zsh; do
      "$pulumiExe" gen-completion $shell >pulumi.$shell
      installShellCompletion pulumi.$shell
    done
  '';

  passthru = {
    pkgs = callPackage ./plugins.nix { };
    withPackages = callPackage ./with-packages.nix { };
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (nix-update-script {
        attrPath = "pulumiPackages.pulumi-go";
        extraArgs = [ "--version=skip" ];
      })
      (nix-update-script {
        attrPath = "pulumiPackages.pulumi-nodejs";
        extraArgs = [ "--version=skip" ];
      })
      (nix-update-script {
        attrPath = "pulumiPackages.pulumi-python";
        extraArgs = [ "--version=skip" ];
      })
    ];
    tests = {
      version = testers.testVersion {
        package = pulumi;
        version = "v${version}";
        command = "PULUMI_SKIP_UPDATE_CHECK=1 pulumi version";
      };
      # Test building packages that reuse our version and src.
      inherit (pulumiPackages) pulumi-go pulumi-nodejs pulumi-python;
      # Pulumi currently requires protobuf4, but Nixpkgs defaults to a newer
      # version. Test that we can actually build the package with protobuf4.
      # https://github.com/pulumi/pulumi/issues/16828
      # https://github.com/NixOS/nixpkgs/issues/351751#issuecomment-2462163436
      pythonPackage =
        (python3Packages.overrideScope (
          final: _: {
            protobuf = final.protobuf4;
          }
        )).pulumi;
      pulumiTestHookShellcheck = testers.shellcheck {
        name = "pulumi-test-hook-shellcheck";
        src = ./extra/pulumi-test-hook.sh;
      };
    };
  };

  meta = {
    homepage = "https://www.pulumi.com";
    description = "Pulumi is a cloud development platform that makes creating cloud programs easy and productive";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.asl20;
    mainProgram = "pulumi";
    maintainers = with lib.maintainers; [
      trundle
      veehaitch
      tie
    ];
  };
}
