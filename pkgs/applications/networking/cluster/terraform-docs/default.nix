{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "terraform-docs";
  version = "0.9.1";


  src = fetchFromGitHub {
    owner  = "segmentio";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "00sfzdqhf8g85m03r6mbzfas5vvc67iq7syb8ljcgxg8l1knxnjx";
  };

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.version=${version}")
  '';

  meta = with lib; {
    description = "A utility to generate documentation from Terraform modules in various output formats";
    homepage = "https://github.com/segmentio/terraform-docs/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}