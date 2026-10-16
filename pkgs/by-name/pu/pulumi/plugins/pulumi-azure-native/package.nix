{
  lib,
  mkPulumiPackage,
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-azure-native";
  version = "3.28.0";
  majorVersion = lib.versions.major version;
  rev = "v${version}";
  hash = "sha256-RVs2BW1E+736/30019NIQrM16/rk9YHNdJji9EOocKI=";
  vendorHash = "sha256-VmOwOM9LQFdNqFPQV9K19s87wLoDiwOTyvaALxaZG84=";
  cmdGen = "pulumi-gen-azure-native";
  cmdRes = "pulumi-resource-azure-native";
  extraLdflags = [
    "-X github.com/pulumi/${repo}/v2/provider/pkg/version.Version=${version}"
  ];
  postPatch = ''
    cp -v ../versions/v${majorVersion}.yaml pkg/versionLookup/default-versions.yaml
  '';
  postConfigure = ''
    pushd ..

    chmod +w . provider/cmd/${cmdRes} sdk/
    chmod -R +w reports/ versions/
    install -dm 0755 bin
    ${cmdGen} schema

    cp bin/schema-full.json provider/cmd/${cmdRes}
    cp bin/metadata-compact.json provider/cmd/${cmdRes}

    popd

    VERSION=v${version} go generate cmd/${cmdRes}/main.go
  '';
  fetchSubmodules = true;
  __darwinAllowLocalNetworking = true;
  meta = {
    description = "Native Azure Pulumi Provider";
    mainProgram = "pulumi-resource-azure-native";
    homepage = "https://github.com/pulumi/pulumi-azure-native";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      veehaitch
    ];
  };
}
