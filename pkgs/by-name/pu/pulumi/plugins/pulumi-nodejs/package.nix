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

  vendorHash = "sha256-8haMHgYUXqnQjW3I82Tp0Jo05xdRqRbixF5yiOzboQw=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${finalAttrs.version}"
  ];

  # Upstream tests shell out into other Pulumi Go modules and currently assume a
  # synced vendor tree that doesn't exist in our isolated build for this package.
  doCheck = false;

  checkFlags = [
    "-skip=^${
      lib.concatStringsSep "$|^" [
        "TestLanguage.*"
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
      ../../dist/pulumi-resource-pulumi-nodejs
  '';

  meta = {
    homepage = "https://www.pulumi.com/docs/iac/languages-sdks/javascript/";
    description = "Language host for Pulumi programs written in TypeScript & JavaScript (Node.js)";
    license = lib.licenses.asl20;
    mainProgram = "pulumi-language-nodejs";
    maintainers = with lib.maintainers; [
      tie
    ];
  };
})
