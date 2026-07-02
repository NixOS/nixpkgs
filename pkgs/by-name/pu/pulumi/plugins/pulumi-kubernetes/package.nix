{
  lib,
  mkPulumiPackage,
  python3Packages,
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-kubernetes";
  version = "4.25.0";
  rev = "v${version}";
  hash = "sha256-CkNTMeiiM8Q4eIEugmid7IKVHplhOAg8YaANSEFodxE=";
  vendorHash = "sha256-L4kJ+oKciJO0B05rcs4lbKpcINxC3gmvR0lC+LdSNeo=";
  cmdGen = "pulumi-gen-kubernetes";
  cmdRes = "pulumi-resource-kubernetes";
  extraLdflags = [
    "-X=github.com/pulumi/${repo}/provider/pkg/version.Version=${version}"
  ];
  pythonArgs.dependencies = with python3Packages; [
    requests
  ];
  meta = {
    description = "Kubernetes resource package, for the Pulumi infrastructure-as-code toolchain";
    mainProgram = "pulumi-resource-kubernetes";
    homepage = "https://www.pulumi.com/docs/reference/clouds/kubernetes/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicoo ];
  };
}
