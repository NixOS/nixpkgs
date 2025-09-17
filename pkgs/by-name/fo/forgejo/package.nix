import ./generic.nix {
  version = "12.0.3";
  hash = "sha256-3uXGDX1uKxXehiMBG1cMIttJFRACIm3UE8U2OtUWjOQ=";
  npmDepsHash = "sha256-V8FUoL9y36bagkg8Scttv/IzKg+MIIqp7witvT8bSWA=";
  vendorHash = "sha256-GE3trnaWuAVSEfi11tZo5JXedWOYOMzcHQ3GFyISVTQ=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
