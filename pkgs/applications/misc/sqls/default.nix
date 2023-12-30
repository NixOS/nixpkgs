{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sqls";
  version = "0.2.27";

  src = fetchFromGitHub {
    owner = "lighttiger2505";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zgaxk4QpaJuKIipGQlxsw80MUfX+UoaUwTkxeHtmrH8=";
  };

  vendorHash = "sha256-BJFSODM2E+z/PDLSqJPhR8FZJisRJUKeaVh6Sn4phtE=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.revision=${src.rev}" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/lighttiger2505/sqls";
    description = "SQL language server written in Go";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
