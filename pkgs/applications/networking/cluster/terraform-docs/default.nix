{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "terraform-docs";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "terraform-docs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XZS+mGp2QsrKS3fPZd0ja4w/CAfPcyzSgwolQ+StER0=";
  };

  vendorHash = "sha256-aweKTHQBYYqSp8CymwhnVv1WNQ7cZ1/bJNz7DSo7PKc=";

  meta = with lib; {
    description = "Utility to generate documentation from Terraform modules in various output formats";
    mainProgram = "terraform-docs";
    homepage = "https://github.com/terraform-docs/terraform-docs/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
