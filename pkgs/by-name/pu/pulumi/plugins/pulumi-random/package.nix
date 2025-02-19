{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildPackages,
  python3Packages,
  testResourceSchema,
  pulumi,
  pulumi-go,
  pulumi-nodejs,
  pulumi-python,
  pulumi-converter-terraform,
  pulumi-random,
  nix-update-script,
}:
buildGoModule rec {
  pname = "pulumi-random";
  version = "4.18.3";

  outputs = [
    "out"
    "sdk"
  ];

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-random";
    tag = "v${version}";
    hash = "sha256-zOwgpm9v9kk5SThT48FbsYXFrJHc1T1U+yuImznMl2o=";
  };

  sourceRoot = "${src.name}/provider";

  vendorHash = "sha256-LgVkX6DWUJhXyfhZhYBMxj3XxOJBXlZ4wb7cQwUH2oY=";
  proxyVendor = true;

  nativeBuildInputs = [
    pulumi
    pulumi-go
    pulumi-nodejs
    pulumi-python
    # TODO: add pulumi-aws and pulumi-azure for docs
    pulumi-converter-terraform
  ];

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
      proxyVendor
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
      PULUMI_CONVERT=1 "$codegen"/bin/pulumi-tfgen-random "$lang" --out "$sdk/$lang"
    done
    cp -t "$sdk/python" ../README.md
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.schema = testResourceSchema {
    package = pulumi-random;
  };

  passthru.sdks.python = python3Packages.pulumi-random;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v(.*)" ];
  };

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
