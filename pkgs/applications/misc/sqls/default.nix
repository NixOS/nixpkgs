{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sqls";
  version = "0.2.28";

  src = fetchFromGitHub {
    owner = "sqls-server";
    repo = "sqls";
    rev = "v${version}";
    hash = "sha256-b3zLyj2n+eKOPBRooS68GfM0bsiTVXDblYKyBYKiYug=";
  };

  vendorHash = "sha256-6IFJvdT7YLnWsg7Icd3nKXXHM6TZKZ+IG9nEBosRCwA=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.revision=${src.rev}" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/sqls-server/sqls";
    description = "SQL language server written in Go";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
