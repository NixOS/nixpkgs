{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildPackages,
  python3Packages,
  testResourceSchema,
  pulumi-random,
  nix-update-script,
}:
buildGoModule rec {
  pname = "pulumi-random";
  version = "4.17.0";

  outputs = [
    "out"
    "sdk"
  ];

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-random";
    tag = "v${version}";
    hash = "sha256-TsVMeE+3EbExfbwvPcGBswWlUVTyjDYolmd3BocBFA4=";
  };

  sourceRoot = "${src.name}/provider";

  vendorHash = "sha256-Vye4M3zJlWArSqHHw7cdzESL4UW6uhx3ih82g8Kk7RE=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi-random/provider/v4/pkg/version.Version=${version}"
  ];

  checkFlags = [
    # Skip integration tests.
    # https://github.com/pulumi/pulumi-random/blob/0eb858b05f27ed5446ede61539d8f55d0923be47/provider/provider_program_test.go#L40
    "-short"
  ];

  excludedPackages = [
    "cmd/pulumi-tfgen-random"
    "shim"
  ];

  codegen = buildPackages.buildGoModule {
    pname = "pulumi-tfgen-random";
    inherit
      src
      version
      sourceRoot
      vendorHash
      ldflags
      ;
    subPackages = [
      "cmd/pulumi-tfgen-random"
      "cmd/pulumi-resource-random/generate.go"
    ];
  };

  # https://github.com/pulumi/pulumi-random/blob/0eb858b05f27ed5446ede61539d8f55d0923be47/Makefile#L262
  postConfigure = ''
    pushd ..
    "$codegen"/bin/pulumi-tfgen-random schema --out provider/cmd/pulumi-resource-random
    popd
    pushd cmd/pulumi-resource-random
    VERSION=$version "$codegen"/bin/generate
    popd
  '';

  postInstall = ''
    for lang in go nodejs python; do
      "$codegen"/bin/pulumi-tfgen-random "$lang" --out "$sdk/$lang"
    done
    cp -t "$sdk/python" ../README.md
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.schema = testResourceSchema {
    package = pulumi-random;
  };

  passthru.sdks.python = python3Packages.pulumi-random;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pulumi provider that safely enables randomness for resources";
    mainProgram = "pulumi-resource-random";
    homepage = "https://github.com/pulumi/pulumi-random";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      veehaitch
      trundle
      tie
    ];
  };
}
