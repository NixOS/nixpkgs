{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "pulumi-terraform-bridge";
  version = "3.124.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-terraform-bridge";
    tag = "v${version}";
    hash = "sha256-0TM9PZmroaUcdk9EHMVhIWv/UNSqZC0LMDM1kBRWb/s=";
  };
  vendorHash = "sha256-0U1X4RheKPpNRU+L8piBlBJ/OhCEOI7Gu6iy612eDLU=";

  meta = {
    description = "This bridge adapts any Terraform Provider built using the Terraform Plugin SDK for use with Pulumi.";
    homepage = "https://github.com/pulumi/pulumi-terraform-bridge";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nicoo
    ];
  };
}
