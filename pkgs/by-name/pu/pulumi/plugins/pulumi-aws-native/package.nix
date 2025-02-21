{
  lib,
  fetchurl,
  fetchFromGitHub,
  runCommand,
  buildGoModule,
  buildPackages,
  python3Packages,
  testResourceSchema,
  pulumi,
  pulumi-go,
  pulumi-nodejs,
  pulumi-python,
  pulumi-aws-native,
  # updateScript
  writers,
  nix,
  git,
}:
buildGoModule rec {
  pname = "pulumi-aws-native";
  version = "1.25.0";

  outputs = [
    "out"
    "sdk"
  ];

  src =
    let
      src = fetchFromGitHub {
        owner = "pulumi";
        repo = "pulumi-aws-native";
        tag = "v${version}";
        hash = "sha256-xA1h3nqiuE1AyDNetnkrhz1zXclvqPk/+bM+GpBMBDA=";
        fetchSubmodules = true;
      };
      # Note: don’t forget to change docsVersion when updating version.
      # https://github.com/pulumi/pulumi-aws-native/blob/v1.25.0/.docs.version
      docsVersion = "957b298e0ead7e37ae0341fdbf6643546b8eb7ed";
      # https://github.com/pulumi/pulumi-aws-native/blob/87838177749c7491e562f074b943b8e9434309c1/Makefile#L43
      docs = fetchurl {
        url = "https://github.com/cdklabs/awscdk-service-spec/raw/${docsVersion}/sources/CloudFormationDocumentation/CloudFormationDocumentation.json";
        hash = "sha256-/VXaaoctYj72ymcVEb78ri+rsOSkIZGG8PhLcFsO2QY=";
      };
    in
    runCommand src.name { inherit src docs docsVersion; } ''
      mkdir -p "$out"
      cp -r -T --reflink=auto "$src" "$out"
      mkdir "$out"/aws-cloudformation-docs
      cp -T "$docs" "$out"/aws-cloudformation-docs/CloudFormationDocumentation.json
    '';

  sourceRoot = "${src.name}/provider";

  vendorHash = "sha256-OQ3DQOlQe9l107Xr5FXlYslEjYjKjxYN9GZnrLO+Tcw=";

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

  passthru.updateScript = writers.writePython3 "pulumi-aws-native-updater" {
    libraries = with python3Packages; [ requests ];
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [
        nix
        git
      ])
    ];
  } ./update.py;

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
