{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "terraform-docs";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "terraform-docs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Jm0ySxn4GFW4iAH3tOIvclcDGJMKzH7m7fhWnAf4+gs=";
  };

  vendorSha256 = "sha256-IzmAlthE6SVvGHj72wrY1/KLehOv8Ck9VaTv5jMpt48=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A utility to generate documentation from Terraform modules in various output formats";
    homepage = "https://github.com/terraform-docs/terraform-docs/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
