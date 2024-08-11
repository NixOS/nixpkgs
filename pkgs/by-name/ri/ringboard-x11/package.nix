{ rustPlatform, ringboard-server }:

rustPlatform.buildRustPackage {
  pname = "ringboard-x11";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "x11";

  cargoHash = "sha256-U9MZOzbNiD8G/8InEHF9lisAf9NNHeVwEHWVer1aeFI=";

  cargoBuildFlags = [ "--no-default-features" ];

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
