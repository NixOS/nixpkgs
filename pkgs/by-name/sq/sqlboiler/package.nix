{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sqlboiler";
  version = "4.19.7";

  src = fetchFromGitHub {
    owner = "volatiletech";
    repo = "sqlboiler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I67MRrsFCLVdslMFwFnrx1EvyR4eUsupRsqD0T9ZCQg=";
  };

  vendorHash = "sha256-ULoyMN54RIFST6P91V3MnRrfiC7+o3LmUFdc0pIqj90=";

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
    changelog = "https://github.com/volatiletech/sqlboiler/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mrityunjaygr8 ];
    mainProgram = "sqlboiler";
  };
})
