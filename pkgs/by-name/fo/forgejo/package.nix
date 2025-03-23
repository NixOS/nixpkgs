import ./generic.nix {
  version = "10.0.2";
  hash = "sha256-UxjhJA6o1LS/7/s0BzcaTSkXSsnKfjIMIjL6ASSot6k=";
  npmDepsHash = "sha256-e3SE6cu1xCBdoMRqp2Gcjcay/EwjF+bTdPOlpL1STvw=";
  vendorHash = "sha256-ceV73QmxYEthjsA50ylojwC4dcTYAbE2UgxuxFqvi24=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
