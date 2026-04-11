{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-jet";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "go-jet";
    repo = "jet";
    rev = "v${version}";
    sha256 = "sha256-BwhatFakmd2ksLQv7OLwvkuDHqnZI4HRnldfyJhR+i8=";
  };

  vendorHash = "sha256-fgYZULAz3orhK637cJNYK7bw9hsQ9PuLH1nMDLVwoGM=";

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
