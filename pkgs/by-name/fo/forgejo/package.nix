import ./generic.nix {
  version = "16.0.4";
  hash = "sha256-oEw8FdJuTfxjMaVxQqbpAIWCYDhxPvifZv8UfqeHbRs=";
  npmDepsHash = "sha256-QwZ8X0pVxs5u4jMOqy3VGcBGVqqDKpLCMPmwoECVwEg=";
  vendorHash = "sha256-GRh9jh7x4xP8MPEEWG0BxKAXtTz3wjueIcPtbkksgqY=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
