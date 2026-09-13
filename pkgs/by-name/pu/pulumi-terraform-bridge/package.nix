{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "pulumi-terraform-bridge";
  version = "3.135.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-terraform-bridge";
    tag = "v${version}";
    hash = "sha256-MMWNIGQz0Mzs4irSV5AqFpx31Jp+liHthHrMsEb0qnE=";
  };
  vendorHash = "sha256-A5JU+TtkYk4Bt5Un+i/EiY1rBcmWOvfIVcYFEyjCPzY=";

  excludedPackages = [
    "tools/pulumi-hcl-lint" # build errors w/ “main module (...) does not contain package”
  ];

  doCheck = false;

  meta = {
    description = "This bridge adapts any Terraform Provider built using the Terraform Plugin SDK for use with Pulumi.";
    homepage = "https://github.com/pulumi/pulumi-terraform-bridge";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nicoo
    ];
  };
}
