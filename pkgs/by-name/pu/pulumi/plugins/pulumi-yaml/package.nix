{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pulumi,
  pulumi-go,
  pulumi-random,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "pulumi-yaml";
  version = "1.26.1";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-yaml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q9IFB7KHurGT9f6Ri2AwwDDdZqGplvQQ0p7k4l6UQYw=";
  };

  vendorHash = "sha256-qhiD+fCMQLqmJsMbEC4xmXhayM2tv4cWmk6aSgJCjaU=";

  subPackages = [
    "cmd/pulumi-converter-yaml"
    "cmd/pulumi-language-yaml"
  ];

  nativeCheckInputs = [
    pulumi
    pulumi-go
    pulumi-random
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi-yaml/pkg/version.Version=${finalAttrs.version}"
  ];

  preCheck = ''
    unset subPackages

    export PULUMI_SKIP_UPDATE_CHECK=true
    export PULUMI_DISABLE_AUTOMATIC_PLUGIN_ACQUISITION=true

    # Required for user.Current implementation with osusergo on Darwin.
    export HOME=$TMPDIR USER=nixbld

    # Expose pulumi-language-yaml program for the tests to use
    export PATH=$PATH:"$GOPATH/bin"
  '';

  checkFlags = [
    "-skip=^${
      lib.concatStringsSep "$|^" [
        # Requires pulumi-test-language program from the main pulumi repo (referenced as git submodule)
        "TestLanguage"

        # pulumi plugin install or depends on pulumi-aws plugin
        "TestGenerateProgram"
        "TestPluginDownloadURLUsed"
        "TestRemoteComponent"
        "TestRemoteComponentTagged"
        "TestResourceOrderingWithDefaultProvider"

        # Requires external schema files
        "TestImportTemplate"
        "TestGenerateExamples"
      ]
    }$"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.pulumi.com/docs/iac/languages-sdks/yaml/";
    description = "Language host for Pulumi programs written in YAML";
    changelog = "https://github.com/pulumi/pulumi-yaml/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "pulumi-language-yaml";
    maintainers = with lib.maintainers; [ folliehiyuki ];
  };
})
