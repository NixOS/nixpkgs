{
  lib,
  fetchurl,
  fetchFromGitHub,
  buildGoModule,
  buildPackages,
  python3Packages,
  testResourceSchema,
  pulumi,
  pulumi-go,
  pulumi-nodejs,
  pulumi-python,
  pulumi-aws-native,
  nix-update-script,
  writers,
  _experimental-update-script-combinators,
}:
buildGoModule rec {
  pname = "pulumi-aws-native";
  version = "1.34.0";

  outputs = [
    "out"
    "sdk"
  ];

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-aws-native";
    tag = "v${version}";
    hash = "sha256-0X9DVTmMEojv85h8mXy+/R/dxMVqZGff5qoTtq9ombk=";
    fetchSubmodules = true;
  };

  # From $src/.docs.version file. Automatically updated by updateScript.
  cloudFormationDocumentation = fetchurl (lib.importJSON ./docs.json);

  sourceRoot = "${src.name}/provider";

  vendorHash = "sha256-A54jvbaZo+SzGV1LWBQo7D1DX4RJmqjuNkZVXjHbgbU=";

  nativeBuildInputs = [
    pulumi
    pulumi-go
    pulumi-nodejs
    pulumi-python
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi-aws-native/provider/pkg/version.Version=${version}"
  ];

  checkFlags = [
    # Skip integration tests.
    # https://github.com/pulumi/pulumi-aws-native/blob/87838177749c7491e562f074b943b8e9434309c1/provider/pkg/provider/provider_2e2_test.go#L84
    "-short"
    # Requires pulumi and pulumi-language-yaml.
    "-skip=^TestE2eSnapshots$"
  ];

  excludedPackages = [
    "cmd/pulumi-gen-aws-native"
    "tools/ref-parser"
  ];

  codegen = buildPackages.buildGoModule {
    pname = "pulumi-gen-aws-native";
    inherit
      src
      version
      sourceRoot
      vendorHash
      ldflags
      ;
    subPackages = [ "cmd/pulumi-gen-aws-native" ];
  };

  postUnpack = ''
    chmod -R +w "$sourceRoot"/..
    mkdir "$sourceRoot"/../aws-cloudformation-docs
    cp -T "$cloudFormationDocumentation" "$sourceRoot"/../aws-cloudformation-docs/CloudFormationDocumentation.json
  '';

  # https://github.com/pulumi/pulumi-aws-native/blob/87838177749c7491e562f074b943b8e9434309c1/Makefile#L70
  postConfigure = ''
    pushd ..
    "$codegen"/bin/pulumi-gen-aws-native \
      -schema-folder aws-cloudformation-schema \
      -version "$version" \
      -metadata-folder meta \
      schema
    popd
  '';

  postInstall = ''
    for lang in go nodejs python; do
      pulumi package gen-sdk cmd/pulumi-resource-aws-native/schema.json \
        --language "$lang" --version "$version" --out "$sdk"
    done
    cp -t "$sdk/python" ../README.md
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.schema = testResourceSchema {
    package = pulumi-aws-native;
    version = null;
  };

  passthru.sdks.python = python3Packages.pulumi-aws-native;

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { extraArgs = [ "--version-regex=v(.*)" ]; })
    (writers.writePython3 "pulumi-aws-native-update-docs" { } ./update-docs.py)
  ];

  meta = {
    description = "Native Pulumi package for creating and managing Amazon Web Services (AWS) resources";
    mainProgram = "pulumi-resource-aws-native";
    homepage = "https://github.com/pulumi/pulumi-aws-native";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      veehaitch
      trundle
      tie
    ];
  };
}
