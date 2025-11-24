{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "sql-migrate";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "rubenv";
    repo = "sql-migrate";
    tag = "v${version}";
    hash = "sha256-zk1ryQSjmO1ziZvMeb3BOb5rvZWgbZm39Sz1N9dJ8dM=";
  };

  vendorHash = "sha256-p/7oKqvbCNWom9q6UaY89GZ4sv0hx1IuzCIw0CH1EwQ=";

  meta = {
    description = "SQL Schema migration tool for Go. Based on gorp and goose";
    homepage = "https://github.com/rubenv/sql-migrate";
    mainProgram = "sql-migrate";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tebro ];
  };
}
