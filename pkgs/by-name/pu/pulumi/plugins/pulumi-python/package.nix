{
  lib,
  buildGoModule,
  callPackage,
  pulumi,
  bash,
  python3,
}:
buildGoModule (finalAttrs: {
  pname = "pulumi-python";
  inherit (pulumi) version src;

  sourceRoot = "${finalAttrs.src.name}/sdk/python/cmd/pulumi-language-python";

  vendorHash = "sha256-k5TaDl6m+S090mn3Xge98pcbZGrnRqaGSjwxb/A4deY=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${finalAttrs.version}"
  ];

  # Upstream tests now depend on extra Python tooling and build-tree fixtures
  # that aren't present in the Nix sandbox for this standalone language host.
  doCheck = false;

  checkFlags = [
    "-skip=^${
      lib.concatStringsSep "$|^" [
        "TestLanguage.*"
        "TestDeterminePulumiPackages"
        "TestListPulumiPackageInfos"
      ]
    }$"
  ];

  nativeCheckInputs = [
    python3
  ];

  # For patchShebangsAuto (see scripts copied in postInstall).
  buildInputs = [
    bash
    python3
  ];

  postInstall = ''
    cp -t "$out/bin" \
      ../pulumi-language-python-exec \
      ../../dist/pulumi-resource-pulumi-python
  '';

  passthru.tests.smokeTest = callPackage ./smoke-test/default.nix { };

  meta = {
    homepage = "https://www.pulumi.com/docs/iac/languages-sdks/python/";
    description = "Language host for Pulumi programs written in Python";
    license = lib.licenses.asl20;
    mainProgram = "pulumi-language-python";
    maintainers = with lib.maintainers; [
      tie
    ];
  };
})
