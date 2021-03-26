{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "terraform-docs";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "terraform-docs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6jUYntnMB/LxyZuRkSaOVcrzJOIoucdaY+5GVHwJL8Y=";
  };

  vendorSha256 = "sha256-HO2E8i5A/2Xi7Pq+Mqb/2ogK1to8IvZjRuDXfzGvOXk=";

  subPackages = [ "." ];

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.version=${version}")
  '';

  meta = with lib; {
    description = "A utility to generate documentation from Terraform modules in various output formats";
    homepage = "https://github.com/terraform-docs/terraform-docs/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
