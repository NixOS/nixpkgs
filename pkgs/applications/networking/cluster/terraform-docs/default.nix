{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "terraform-docs";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "terraform-docs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-x2YTd4ZnimTRkFWbwFp4qz6BymD6ESVxBy6YE+QqQ6k=";
  };

  vendorSha256 = "sha256-drfhfY03Ao0fqleBdzbAnPsE4kVrJMcUbec0txaEIP0=";

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
