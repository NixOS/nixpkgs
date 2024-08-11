{ rustPlatform, ringboard-server }:

rustPlatform.buildRustPackage {
  pname = "ringboard-egui";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "egui";

  cargoHash = "";

  meta = {
    inherit (ringboard-server.meta)
      homepage
      changelog
      license
      maintainers
      platforms
      ;
    description = "X11 clipboard watcher for Rinboard, a clipboard manager for Linux";
    mainProgram = "ringboard"; # TODO: check
  };
}
