{
  lib,
  buildGoModule,
  pulumi,
}:
buildGoModule (finalAttrs: {
  pname = "pulumi-go";
  inherit (pulumi) version src;

  sourceRoot = "${finalAttrs.src.name}/sdk/go/pulumi-language-go";

  vendorHash = "sha256-QTbM9r61yq281y2l2wlpHXhPNG2D+GLmc54U46jQ+p4=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${finalAttrs.version}"
  ];

  checkFlags = [
    "-skip=^${
      lib.concatStringsSep "$|^" [
        "TestLanguagePublished"
        "TestLanguageLocal"
        "TestLanguageExtraTypes"
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
      untio11
      wrbbz
    ];
  };
})
