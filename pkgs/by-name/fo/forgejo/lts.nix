import ./generic.nix {
  version = "15.0.8";
  hash = "sha256-tpgqa6RvQ/xesSv/THjlXiM0JQqzgMQJiuUAOFrgGpo=";
  npmDepsHash = "sha256-g3ebO2W8lnHeS6T6bMJkC/UVDA3pa5O5v64QJG5irn0=";
  vendorHash = "sha256-p9U/nvAHSC2Pj09gfDWQVKl+1TKB0PTqW2E+gKZ4/D4=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
