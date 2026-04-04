import ./generic.nix {
  version = "14.0.3";
  hash = "sha256-WE0CUwF5GBUr6+kUeHyPa0XPy5uigol/74eQhQQjBQA=";
  npmDepsHash = "sha256-tJmX6VO7T6T4egy+Z2RZhe+/6ZfS6ZHFETfALmfAli4=";
  vendorHash = "sha256-TpRVaXNlfnmFu8EdvKN8/mioLeQkghCy0nMWvRB6sYQ=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
