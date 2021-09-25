{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "terraform-docs";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "terraform-docs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PzGlEEhootf2SCOy7+11aST7NMTNhNMQWeZO40mrMYQ=";
  };

  vendorSha256 = "sha256-T/jgFPBUQMATX7DoWsDR/VFjka7Vxk7F4taE25cdnTk=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A utility to generate documentation from Terraform modules in various output formats";
    homepage = "https://github.com/terraform-docs/terraform-docs/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
