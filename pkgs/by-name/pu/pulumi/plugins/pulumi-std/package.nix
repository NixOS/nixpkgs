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
  pulumi-std,
  nix-update-script,
}:
buildGoModule rec {
  pname = "pulumi-std";
  version = "2.2.0";

  outputs = [
    "out"
    "sdk"
  ];

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-std";
    tag = "v${version}";
    hash = "sha256-qyp13SXmo4ZPCqnbtqnKwe9jtKSNrvCD/jMjRK15Bbk=";
  };

  sourceRoot = "${src.name}/std";

  vendorHash = "sha256-APB+e0CK0x5reavEi9QPo6J5WWXks3tvwU+28aGKp7g=";

  nativeBuildInputs = [
    pulumi
    pulumi-go
    pulumi-nodejs
    pulumi-python
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi-std/std/version.Version=${version}"
  ];

  codegen = buildPackages.buildGoModule {
    inherit
      src
      pname
      version
      sourceRoot
      vendorHash
      ldflags
      ;
    subPackages = [ "cmd/pulumi-resource-std" ];
  };

  postInstall = ''
    pulumi package get-schema "$codegen/bin/pulumi-resource-std" >schema.json
    for lang in go nodejs python; do
      pulumi package gen-sdk schema.json --language "$lang" --out "$sdk"
    done
    cp -t "$sdk/python" ../README.md
    substituteInPlace "$sdk/python/setup.py" \
      --replace-fail 'VERSION = "0.0.0"' "VERSION = \"$version\""
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.schema = testResourceSchema {
    package = pulumi-std;
  };

  passthru.sdks.python = python3Packages.pulumi-std;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Standard library functions implemented as a native Pulumi provider";
    mainProgram = "pulumi-resource-std";
    homepage = "https://github.com/pulumi/pulumi-std";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
