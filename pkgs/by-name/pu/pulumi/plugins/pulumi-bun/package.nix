{
  lib,
  buildGoModule,
  symlinkJoin,
  pulumi,
  pulumi-nodejs,
}:
let
  unwrapped = buildGoModule (finalAttrs: {
    pname = "pulumi-bun-unwrapped";
    inherit (pulumi) version src;

    sourceRoot = "${finalAttrs.src.name}/sdk/nodejs/cmd/pulumi-language-bun";

    vendorHash = null;

    ldflags = [
      "-s"
      "-w"
      "-X=github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${finalAttrs.version}"
    ];
  });
in
symlinkJoin (finalAttrs: {
  pname = "pulumi-bun";
  inherit (pulumi) version;

  paths = [
    unwrapped
    pulumi-nodejs
  ];

  passthru = {
    inherit unwrapped;
  };

  meta = {
    homepage = "https://www.pulumi.com/docs/iac/languages-sdks/javascript/";
    description = "Language host for Pulumi programs written in TypeScript & JavaScript (Bun)";
    license = lib.licenses.asl20;
    mainProgram = "pulumi-language-bun";
    maintainers = with lib.maintainers; [
      tie
    ];
  };
})
