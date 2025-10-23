{
  lib,
  buildGoModule,
  callPackage,
  pulumi,
  bash,
  python3,
}:
buildGoModule rec {
  pname = "pulumi-python";
  inherit (pulumi) version src;

  sourceRoot = "${src.name}/sdk/python/cmd/pulumi-language-python";

  vendorHash = "sha256-BfkjDesPdPDV2uILYaMJFIvaEBKT15ukwaReAL3yziw=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];

  checkFlags = [
    "-skip=^${
      lib.concatStringsSep "$|^" [
        "TestLanguage"
        "TestDeterminePulumiPackages"
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
      ../../dist/pulumi-resource-pulumi-python \
      ../../dist/pulumi-analyzer-policy-python
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
}
