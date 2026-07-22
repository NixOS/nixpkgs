import ./generic.nix {
  version = "16.0.1";
  hash = "sha256-fMAOmYh21nMyd9b8e6cXlh7ArJtIys3N6sbTJNV1oyw=";
  npmDepsHash = "sha256-UhivpUqNJvc3zHxdRVAWT9x68jG1KnQa8yS4KkL2W5g=";
  vendorHash = "sha256-elbuQxUtbuDTJV686ZqiFgxWlIYrWDZ4fUet2QY/sJ8=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
