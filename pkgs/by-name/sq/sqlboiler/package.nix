{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sqlboiler";
  version = "4.17.1";

  src = fetchFromGitHub {
    owner = "volatiletech";
    repo = "sqlboiler";
    rev = "refs/tags/v${version}";
    hash = "sha256-hb8aMaK2iDDCEJXoNn9BLELP0J7LcJzsQdSYZe1tcjQ=";
  };

  vendorHash = "sha256-ZGGoTWSbGtsmrEQcZI40z6QF6qh4t3LN17Sox4KHQMA=";

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
