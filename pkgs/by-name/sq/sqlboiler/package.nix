{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sqlboiler";
  version = "4.18.0";

  src = fetchFromGitHub {
    owner = "volatiletech";
    repo = "sqlboiler";
    tag = "v${version}";
    hash = "sha256-gpRegyW6LrKj45MDl+eOKrTqTo1wn7JOd4zPDexOB6M=";
  };

  vendorHash = "sha256-BTrQPWThfJ7gWXi/Y1l/s2BmkW5lVYS/PP0WRwntQxA=";

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
