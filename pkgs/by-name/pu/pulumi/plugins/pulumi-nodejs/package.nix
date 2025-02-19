{
  lib,
  buildGoModule,
  pulumi,
  bash,
  nodejs,
  python3,
}:
let
  inherit (pulumi) version src;
in
buildGoModule {
  pname = "pulumi-nodejs";
  inherit version src;

  sourceRoot = "${src.name}/sdk/nodejs/cmd/pulumi-language-nodejs";

  vendorHash = "sha256-q+7/bD0AfonJ522Z0olT9Gfv6XNaqm3Scqg7v6dfWXc=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];

  checkFlags = [
    "-skip=^${
      lib.concatStringsSep "$|^" [
        "TestLanguage"
        "TestGetProgramDependencies"
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
      ../../dist/pulumi-resource-pulumi-nodejs \
      ../../dist/pulumi-analyzer-policy
  '';

  meta = {
    homepage = "https://www.pulumi.com/docs/iac/languages-sdks/javascript/";
    description = "Language host for Pulumi programs written in TypeScript & JavaScript (Node.js)";
    license = lib.licenses.asl20;
    mainProgram = "pulumi-language-nodejs";
    maintainers = with lib.maintainers; [
      trundle
      veehaitch
      tie
    ];
  };
}
