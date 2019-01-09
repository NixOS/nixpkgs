{ lib, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "terraform-docs";
  version = "0.5.0";

  goPackagePath = "github.com/segmentio/${pname}";

  src = fetchFromGitHub {
    owner  = "segmentio";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "12w2yr669hk5kxdb9rrzsn8hwvx8rzrc1rmn8hs9l8z1bkfhr4gg";
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
