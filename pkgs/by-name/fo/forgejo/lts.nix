import ./generic.nix {
  version = "15.0.10";
  hash = "sha256-pc97BrybZatSfBgIRJGXodMaltPSv3+/1AFAx9U7GTo=";
  npmDepsHash = "sha256-cR8lIw11G57tmHFJIU9YercxC9p0IUNJ+vUSfonHSOU=";
  vendorHash = "sha256-tIQmzsPVf5Ka3LmJJxlju750Ja1BKN3JX+8HRyjze+0=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
