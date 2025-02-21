{
  lib,
  applyPatches,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "pulumi-yaml";
  version = "1.13.1";

  src =
    (fetchFromGitHub {
      owner = "pulumi";
      repo = "pulumi-yaml";
      tag = "v${version}";
      hash = "sha256-pigXpUhIzSAKzZOZJcH9pSKxgNJGaq8PdVmDBkkp/Jo=";
      fetchSubmodules = true;
    }).overrideAttrs
      (oldAttrs: {
        # https://github.com/NixOS/nixpkgs/issues/195117#issuecomment-1410398050
        env = oldAttrs.env or { } // {
          GIT_CONFIG_COUNT = 1;
          GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
          GIT_CONFIG_VALUE_0 = "git@github.com:";
        };
      });

  patches = [
    ./schema-loader.patch
  ];

  vendorHash = "sha256-7uygZNvQ25dOecntVvTlo3Bd6UEqqq9EbuVwqauUiK0=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi-yaml/pkg/version.Version=${version}"
  ];

  excludedPackages = [
    "pulumi/"
    "scripts/gocov"
    "pkg/tests/testprovider"
  ];

  checkFlags = [
    # Skip integration tests.
    "-short"
    "-skip=^${
      lib.concatStringsSep "$|^" [
        # Requires pulumi submodule with pulumi-language-test.
        "TestLanguage"
        # Requires output from scripts/get_schemas.json.
        "TestGenerateExamples"
        "TestGenerateProgram"
        "TestImportTemplate"
        # Requires pulumi executable.
        "TestParameterized"
        "TestAbout"
        "TestLocalPlugin"
        "TestResourceOrderingWithDefaultProvider"
        "TestResourceSecret"
        "TestProjectConfigWithSecret"
        "TestEnvVarsKeepConflictingValues"
        "TestEnvVarsPassedToExecCommand"
        "TestProjectConfigWithSecretDecrypted"
      ]
    }$"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.pulumi.com/docs/iac/languages-sdks/yaml/";
    description = "Language host for Pulumi programs written in YAML";
    license = lib.licenses.asl20;
    mainProgram = "pulumi-language-yaml";
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
