{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sqlboiler";
  version = "4.19.2";

  src = fetchFromGitHub {
    owner = "volatiletech";
    repo = "sqlboiler";
    tag = "v${version}";
    hash = "sha256-rT0aNF7+AMO7oin5qh/IXZWt3+3b9PU4ytH6TKieEZY=";
  };

  vendorHash = "sha256-LMHFDOKZQa0DJLHehRBzGGlb7apppnMDbjnJ4spuZtA=";

  tags = [
    "mysql"
    "go"
    "golang"
    "postgres"
    "orm"
    "database"
    "postgresql"
    "mssql"
    "sqlite3"
    "sqlboiler"
  ];

  doCheck = false;

  meta = {
    description = "Generate a Go ORM tailored to your database schema";
    homepage = "https://github.com/volatiletech/sqlboiler";
    changelog = "https://github.com/volatiletech/sqlboiler/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mrityunjaygr8 ];
    mainProgram = "sqlboiler";
  };
}
