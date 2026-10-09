import ./generic.nix {
  version = "15.0.9";
  hash = "sha256-6EtUVoB8/PsgbWiB4j9hLYOYyjPKCykzILWezDpJnAs=";
  npmDepsHash = "sha256-g3ebO2W8lnHeS6T6bMJkC/UVDA3pa5O5v64QJG5irn0=";
  vendorHash = "sha256-KW0WIfRm53pVOiWOYoSQaCz7BO+lFykAQdgdgXesXkY=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
