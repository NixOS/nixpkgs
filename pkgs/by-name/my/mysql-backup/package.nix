{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  name = "mysql-backup";
  version = "1.0.0-rc3";

  src = fetchFromGitHub {
    owner = "ramblurr";
    repo = "mysql-backup";
    rev = "da43226cce801e488efcf037529084f6da13df44";
    hash = "sha256-gAJ05sWeo4MqG6rJXfArOypU1M8FHIzp5lLM560EsTo=";
  };

  vendorHash = "sha256-2pa9DKnkAhyF/XyDpPCcXJZbSaWQWoSsk3uTUEJAxPc=";

  meta = {
    description = "A simple way to manage MySQL backups and restores";
    changelog = "https://github.com/databacker/mysql-backup/releases/tag/v${version}";
    homepage = "https://github.com/databacker/mysql-backup";
    license = lib.licenses.mit;
    mainProgram = "mysql-backup";
    maintainers = with lib.maintainers; [ ramblurr ];
  };
}
