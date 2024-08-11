{ rustPlatform, ringboard-server }:

rustPlatform.buildRustPackage {
  pname = "ringboard-tui";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "tui";

  cargoHash = "sha256-PI9oigAiBM3gwUDsxDAjoeDEmip/HEoXhf3vZ13TAy0=";

  meta = {
    inherit (ringboard-server.meta)
      homepage
      changelog
      license
      maintainers
      platforms
      ;
    description = "TUI client for Rinboard, a clipboard manager for Linux";
    mainProgram = "ringboard"; # TODO: check
  };
}
