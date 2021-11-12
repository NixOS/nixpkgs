{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sqls";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "lighttiger2505";
    repo = pname;
    rev = "v${version}";
    sha256 = "1myypq9kdfbhl5h9h8d30a3pi89mix48wm1c38648ky9vhx0s4az";
  };

  vendorSha256 = "13c7nv0anj260z34bd7w1hz0rkmsj9r1zz55qiwcr1vdgmvy84cz";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.revision=${src.rev}" ];

  meta = with lib; {
    homepage = "https://github.com/lighttiger2505/sqls";
    description = "SQL language server written in Go";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
