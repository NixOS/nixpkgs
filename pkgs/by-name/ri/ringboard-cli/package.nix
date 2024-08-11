{ rustPlatform, ringboard-server }:

rustPlatform.buildRustPackage {
  pname = "ringboard-cli";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "cli";

  cargoHash = "sha256-zQe2CExDGyqZiILS5FUiMBBeQgD7Se59YGqxsu1Q5Po=";

  meta = {
    inherit (ringboard-server.meta)
      homepage
      changelog
      license
      maintainers
      platforms
      ;
    description = "CLI for Rinboard, a clipboard manager for Linux";
    mainProgram = "ringboard"; # TODO: check
  };
}
