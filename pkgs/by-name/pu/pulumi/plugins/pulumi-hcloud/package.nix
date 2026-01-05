{
  lib,
  mkPulumiPackage,
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-hcloud";
  version = "1.20.4";
  rev = "v${version}";
  hash = "sha256-m9MRXDTSC0K1raoH9gKPuxdwvUEnZ/ulp32xlY1Hsdo=";
  vendorHash = "sha256-u3mxaOEXQod1MDFxo85YdOb6Bx/9G5uaa3ykhnmcqCg=";
  cmdGen = "pulumi-tfgen-hcloud";
  cmdRes = "pulumi-resource-hcloud";
  extraLdflags = [
    "-X=github.com/pulumi/${repo}/provider/pkg/version.Version=v${version}"
  ];
  __darwinAllowLocalNetworking = true;
  meta = with lib; {
    description = "Hetzner Cloud Pulumi resource package, providing multi-language access to Hetzner Cloud";
    mainProgram = "pulumi-resource-hcloud";
    homepage = "https://github.com/pulumi/pulumi-hcloud";
    license = licenses.asl20;
    maintainers = with maintainers; [ tie ];
  };
}
