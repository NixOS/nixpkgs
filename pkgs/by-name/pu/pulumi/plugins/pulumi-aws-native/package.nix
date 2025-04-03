{
  lib,
  mkPulumiPackage,
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-aws-native";
  version = "0.38.0";
  rev = "v${version}";
  hash = "sha256-v7jNPCrjtfi9KYD4RhiphMIpV23g/CBV/sKPBkMulu0=";
  vendorHash = "sha256-Yu9tNakwXWYdrjzI6/MFRzVBhJAEOjsmq9iBAQlR0AI=";
  cmdGen = "pulumi-gen-aws-native";
  cmdRes = "pulumi-resource-aws-native";
  extraLdflags = [
    "-X github.com/pulumi/${repo}/provider/pkg/version.Version=v${version}"
  ];

  fetchSubmodules = true;
  postConfigure = ''
    pushd ..

    ${cmdGen} schema aws-cloudformation-schema ${version}

    popd
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Native AWS Pulumi Provider";
    mainProgram = "pulumi-resource-aws-native";
    homepage = "https://github.com/pulumi/pulumi-aws-native";
    license = licenses.asl20;
    maintainers = with maintainers; [
      veehaitch
      trundle
    ];
  };
}
