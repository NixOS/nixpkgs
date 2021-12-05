{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sqls";
  version = "0.2.20";

  src = fetchFromGitHub {
    owner = "lighttiger2505";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QYxiWxgzuD+JymlXlVmzZOtex70JC93VmWljAFQJMPQ=";
  };

  vendorSha256 = "sha256-fo5g6anMcKqdzLG8KCJ/T4uTOp1Z5Du4EtCHYkLgUpo=";

  ldflags =
    [ "-s" "-w" "-X main.version=${version}" "-X main.revision=${src.rev}" ];

  meta = with lib; {
    homepage = "https://github.com/lighttiger2505/sqls";
    description = "SQL language server written in Go";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
