{
  lib,
  buildGoModule,
  pulumi,
  bash,
  nodejs,
  python3,
}:
buildGoModule (finalAttrs: {
  pname = "pulumi-nodejs";
  inherit (pulumi) version src;

  sourceRoot = "${finalAttrs.src.name}/sdk/nodejs/cmd/pulumi-language-nodejs";

  vendorHash = "sha256-+ZlUFiSDrq3KGvXMT+uQIQL78aMW+UVmyFO6iZ2X4AA=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${finalAttrs.version}"
  ];

  checkFlags = [
    "-skip=^${
      lib.concatStringsSep "$|^" [
        "TestGetProgramDependencies"
        "TestLanguageTSC"
        "TestLanguageTSNode"
        "TestLanguageBun"
      ]
    }$"
  ];

  nativeCheckInputs = [
    python3 # for TestNonblockingStdout
    nodejs
  ];

  # For patchShebangsAuto (see scripts copied in postInstall).
  buildInputs = [
    bash
  ];

  postInstall = ''
    cp -t "$out/bin" \
      ../../dist/pulumi-resource-pulumi-nodejs
  '';

  meta = {
    homepage = "https://www.pulumi.com/docs/iac/languages-sdks/javascript/";
    description = "Language host for Pulumi programs written in TypeScript & JavaScript (Node.js)";
    license = lib.licenses.asl20;
    mainProgram = "pulumi-language-nodejs";
    maintainers = with lib.maintainers; [
      tie
      untio11
    ];
  };
})
