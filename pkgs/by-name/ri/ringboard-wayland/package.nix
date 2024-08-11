{ rustPlatform, ringboard-server }:

rustPlatform.buildRustPackage {
  pname = "ringboard-wayland";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "wayland";

  cargoHash = "sha256-ntfm9SWaw7spyb4ji33si1kF7u3VT1WSQAECcCchAi4=";

  cargoBuildFlags = [ "--no-default-features" ];

  meta = {
    inherit (ringboard-server.meta)
      homepage
      changelog
      license
      maintainers
      platforms
      ;
    description = "Wayland clipboard watcher for Rinboard, a clipboard manager for Linux";
    mainProgram = "ringboard"; # TODO: check
  };
}
