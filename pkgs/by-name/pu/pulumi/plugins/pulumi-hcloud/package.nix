{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildPackages,
  python3Packages,
  testResourceSchema,
  pulumi-hcloud,
  nix-update-script,
}:
buildGoModule rec {
  pname = "pulumi-hcloud";
  version = "1.21.2";

  outputs = [
    "out"
    "sdk"
  ];

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-hcloud";
    tag = "v${version}";
    hash = "sha256-C5yMvlbtXsv4YZmvekR9Fld5hChsFLQMZ2k1D/5rkSU=";
  };

  sourceRoot = "${src.name}/provider";

  vendorHash = "sha256-il6PB3aHSCHHZ61A1UXz7lKsCY/zBu6y59kzScMyTMY=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi-hcloud/provider/pkg/version.Version=${version}"
  ];

  checkFlags = [
    # Skip integration tests.
    # https://github.com/pulumi/pulumi-hcloud/blob/85451a144fdb627dd190e62d1f1400f665223fd5/provider/provider_program_test.go#L34
    "-short"
  ];

  excludedPackages = [
    "cmd/pulumi-tfgen-hcloud"
  ];

  codegen = buildPackages.buildGoModule {
    pname = "pulumi-tfgen-hcloud";
    inherit
      src
      version
      sourceRoot
      vendorHash
      ldflags
      ;
    subPackages = [
      "cmd/pulumi-tfgen-hcloud"
      "cmd/pulumi-resource-hcloud/generate.go"
    ];
  };

  # https://github.com/pulumi/pulumi-hcloud/blob/85451a144fdb627dd190e62d1f1400f665223fd5/Makefile#L259
  postConfigure = ''
    pushd ..
    "$codegen"/bin/pulumi-tfgen-hcloud schema --out provider/cmd/pulumi-resource-hcloud
    popd
    pushd cmd/pulumi-resource-hcloud
    VERSION=$version "$codegen"/bin/generate
    popd
  '';

  postInstall = ''
    for lang in go nodejs python; do
      "$codegen"/bin/pulumi-tfgen-hcloud "$lang" --out "$sdk/$lang"
    done
    cp -t "$sdk/python" ../README.md
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.schema = testResourceSchema {
    package = pulumi-hcloud;
  };

  passthru.sdks.python = python3Packages.pulumi-hcloud;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pulumi package for creating and managing Hetzner Cloud resources";
    mainProgram = "pulumi-resource-hcloud";
    homepage = "https://github.com/pulumi/pulumi-hcloud";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
