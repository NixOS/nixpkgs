{ lib, attic-client }:
lib.addMetaAttrs { mainProgram = "atticd"; } (
  attic-client.override { crates = [ "attic-server" ]; }
)
