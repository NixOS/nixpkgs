{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildPackages,
  python3Packages,
  testResourceSchema,
  pulumi,
  pulumi-nodejs,
  pulumi-python,
  pulumi-azure-native,
  nix-update-script,
}:
buildGoModule rec {
  pname = "pulumi-azure-native";
  version = "3.8.0";

  outputs = [
    "out"
    "sdk"
  ];

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-azure-native";
    tag = "v${version}";
    hash = "sha256-7LHzTFBGXamAWq8uMeDE7O19yx/jNmhmLaWPBmwIsrk=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/provider";

  vendorHash = "sha256-JPkgwhOgyrfWZaEzs6FpN54OhnbJjNQqwrDGFqrK9FY=";

  nativeBuildInputs = [
    pulumi
    pulumi-nodejs
    pulumi-python
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi-azure-native/v2/provider/pkg/version.Version=${version}"
  ];

  checkFlags = [
    # Skip integration tests.
    # https://github.com/pulumi/pulumi-azure-native/blob/ef5931469519463ce7053e34b40fa6e969bd0302/provider/pkg/provider/provider_e2e_test.go#L149
    "-short"
    # Also an integration test, but not marked with t.Short.
    # https://github.com/pulumi/pulumi-azure-native/blame/4b50bddc5be536b3bd359cbcc7925ff59ded2a12/provider/pkg/provider/provider_parameterize_test.go#L336
    "-skip=^TestParameterizePackageAdd$"
  ];

  excludedPackages = [
    "cmd/pulumi-gen-azure-native"
  ];

  codegen = buildPackages.buildGoModule {
    pname = "pulumi-gen-azure-native";
    inherit
      src
      version
      sourceRoot
      vendorHash
      ldflags
      ;
    # https://github.com/pulumi/pulumi-azure-native/blob/ef5931469519463ce7053e34b40fa6e969bd0302/Makefile#L314
    postConfigure = ''
      pushd ..
      cp -T \
        "versions/v''${version%%.*}.yaml" \
        provider/pkg/versionLookup/default-versions.yaml
      popd
    '';
    subPackages = [ "cmd/pulumi-gen-azure-native" ];
  };

  postUnpack = ''
    chmod -R +w "$sourceRoot"/..
  '';

  # https://github.com/pulumi/pulumi-azure-native/blob/ef5931469519463ce7053e34b40fa6e969bd0302/Makefile#L308
  postConfigure = ''
    pushd ..
    rm provider/cmd/pulumi-resource-azure-native/schema.json
    "$codegen"/bin/pulumi-gen-azure-native schema
    cp -t provider/cmd/pulumi-resource-azure-native \
      bin/schema-full.json bin/metadata-compact.json
    cp -T \
      "versions/v''${version%%.*}.yaml" \
      provider/pkg/versionLookup/default-versions.yaml
    popd
  '';

  postInstall = ''
    pushd ..
    "$codegen"/bin/pulumi-gen-azure-native go
    mkdir -p "$sdk/go"
    cp -r -T "sdk/pulumi-azure-native-sdk" "$sdk/go"
    for lang in nodejs python; do
      pulumi package gen-sdk bin/schema-full.json \
        --language "$lang" --version "$version" --out "$sdk"
    done
    popd
    cp -t "$sdk/python" ../README.md
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.schema = testResourceSchema {
    package = pulumi-azure-native;
  };

  passthru.sdks.python = python3Packages.pulumi-azure-native;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native Pulumi package for creating and managing Azure resources";
    mainProgram = "pulumi-resource-azure-native";
    homepage = "https://github.com/pulumi/pulumi-azure-native";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      veehaitch
      trundle
      tie
    ];
  };
}
