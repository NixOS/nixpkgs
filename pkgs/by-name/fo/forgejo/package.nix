import ./generic.nix {
  version = "12.0.4";
  hash = "sha256-g6PNJYiGR7tUpurVL1gvGzJzDoMCLmkGiLLsSZfkbYQ=";
  npmDepsHash = "sha256-V8FUoL9y36bagkg8Scttv/IzKg+MIIqp7witvT8bSWA=";
  vendorHash = "sha256-GE3trnaWuAVSEfi11tZo5JXedWOYOMzcHQ3GFyISVTQ=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
