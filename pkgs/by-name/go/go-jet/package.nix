{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-jet";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "go-jet";
    repo = "jet";
    rev = "v${version}";
    sha256 = "sha256-f3BqcXRugw19LQI3Jz8v1dY0bLUhtFKeVBsfQ9rZEow=";
  };

  vendorHash = "sha256-NSuZNq5nHuekzEgjG+x8ieb8dkKmWeZNERP6759f01Q=";

  subPackages = [ "cmd/jet" ];

  tags = [
    "mysql"
    "golang"
    "postgres"
    "sql"
    "database"
    "code-generator"
    "sqlite"
    "postgresql"
    "mariadb"
    "sql-query"
    "codegenerator"
    "typesafe"
    "sql-builder"
    "datamapper"
    "code-completion"
    "sql-queries"
    "cockroachdb"
    "sql-query-builder"
    "sqlbuilder"
    "typesafety"
  ];

  postPatch = ''
    # removing the tests which depend on external data
    rm -rf tests/{sqlite,postgres,mysql}
  '';

  meta = {
    homepage = "https://github.com/go-jet/jet";
    description = "Type safe SQL builder with code generation and automatic query result data mapping";
    maintainers = with lib.maintainers; [ mrityunjaygr8 ];
    license = lib.licenses.asl20;
    mainProgram = "jet";
  };
}
