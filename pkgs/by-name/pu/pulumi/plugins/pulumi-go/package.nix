{
  lib,
  buildGoModule,
  pulumi,
}:
buildGoModule rec {
  pname = "pulumi-go";
  inherit (pulumi) version src;

  sourceRoot = "${src.name}/sdk/go/pulumi-language-go";

  vendorHash = "sha256-jwsdMSLDn2PNJFIIVhqwBLH7acFTOFLPgVNMKbI5DZE=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];

  checkFlags = [
    "-skip=^${
      lib.concatStringsSep "$|^" [
        "TestLanguage"
        "TestPluginsAndDependencies_vendored"
        "TestPluginsAndDependencies_subdir"
        "TestPluginsAndDependencies_moduleMode"
      ]
    }$"
  ];

  meta = {
    homepage = "https://www.pulumi.com/docs/iac/languages-sdks/go/";
    description = "Language host for Pulumi programs written in Go";
    license = lib.licenses.asl20;
    mainProgram = "pulumi-language-go";
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
