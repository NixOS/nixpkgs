{ radicle-node }:

radicle-node.override {
  version = "1.9.0-rc.1";
  srcHash = "sha256-CM1BdpdnAyAelrPAJjvsD7qOfHkV3EEmF4pTNOFvQik=";
  cargoHash = "sha256-N28PQpuTcDAszWF0TPY/H5uzWfQZSuxn0XVYLeKNmn0=";
  updateScript = ./update-unstable.sh;
}
