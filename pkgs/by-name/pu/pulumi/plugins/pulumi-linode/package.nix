{
  lib,
  mkPulumiPackage,
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-linode";
  version = "5.4.0";
  rev = "v${version}";
  hash = "sha256-XfZKiGODCncvbHRc4EuwItMWuJyliFxud5GO2X4h1qg=";
  vendorHash = "sha256-dabWCYvIvPeHgbDGlgULAyLAARO5IYqYnSkUs5p6/PM=";
  cmdGen = "pulumi-tfgen-linode";
  cmdRes = "pulumi-resource-linode";
  extraLdflags = [
    "-X=github.com/pulumi/${repo}/provider/v5/pkg/version.Version=v${version}"
  ];
  __darwinAllowLocalNetworking = true;
  meta = {
    description = "Linode Pulumi resource package, providing multi-language access to Linode";
    mainProgram = "pulumi-resource-linode";
    homepage = "https://github.com/pulumi/pulumi-linode";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ purcell ];
  };
}
