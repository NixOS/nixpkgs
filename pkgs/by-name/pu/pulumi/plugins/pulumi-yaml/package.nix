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
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-yaml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2RRr05yrNWd1zePzgIl2ZS0yZ0t6gRkAM9qh4HlSeVI=";
  };

  vendorHash = "sha256-3jj8LQz1pq24YTw5uawWvpDGSkBtGeCqGAS2AvFPTUc=";

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
    maintainers = with lib.maintainers; [
      folliehiyuki
    ];
  };
})
