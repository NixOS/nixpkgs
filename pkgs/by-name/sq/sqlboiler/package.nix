{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sqlboiler";
  version = "4.19.1";

  src = fetchFromGitHub {
    owner = "volatiletech";
    repo = "sqlboiler";
    tag = "v${version}";
    hash = "sha256-BZZL1nRd2YGj5wJNKkla+Ve4OQ1iU/8r82yjJxmc43M=";
  };

  vendorHash = "sha256-AFpJjngGZJ14Gfg6FEavZOR6WdboJYAweaLtqB9jm1k=";

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

  meta = with lib; {
    description = "Generate a Go ORM tailored to your database schema";
    homepage = "https://github.com/volatiletech/sqlboiler";
    changelog = "https://github.com/volatiletech/sqlboiler/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mrityunjaygr8 ];
    mainProgram = "sqlboiler";
  };
}
