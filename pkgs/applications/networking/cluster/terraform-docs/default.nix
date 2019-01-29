{ lib, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "terraform-docs";
  version = "0.6.0";

  goPackagePath = "github.com/segmentio/${pname}";

  src = fetchFromGitHub {
    owner  = "segmentio";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1p6prhjf82qnhf1zwl9h92j4ds5g383a6g9pwwnqbc3wdwy5zx7d";
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
