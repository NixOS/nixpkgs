import ./generic.nix {
  version = "10.0.0";
  hash = "sha256-FcXL+lF2B+EUUEbdD31b1pV7GWbYxk6ewljAXuiV8QY=";
  npmDepsHash = "sha256-YQDTw5CccnR7zJpvvEcmHZ2pLLNGYEg/mvncNYzcYY8=";
  vendorHash = "sha256-fqHwqpIetX2jTAWAonRWqF1tArL7Ik/XXURY51jGOn0=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
