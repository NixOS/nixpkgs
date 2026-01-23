{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "sql-migrate";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "rubenv";
    repo = "sql-migrate";
    tag = "v${version}";
    hash = "sha256-hq0qpg9KE7Gb8W5ur1kKSFGJOwsUujIuc+XUykdgEQ0=";
  };

  vendorHash = "sha256-+2Sr/1SJwyUnSgmLGdqnw24wwndHwtwsFGanX6aVVKU=";

  meta = {
    description = "SQL Schema migration tool for Go. Based on gorp and goose";
    homepage = "https://github.com/rubenv/sql-migrate";
    mainProgram = "sql-migrate";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tebro ];
  };
}
