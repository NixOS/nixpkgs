import ./generic.nix {
  version = "9.0.1";
  hash = "sha256-j+lgLorwSEgWrg45GtEKgXEqb38pHtkZ3CgqRSKbXKk=";
  npmDepsHash = "sha256-SD+xCFESNZQJJH/daSycEZsYiFdVSJFAncbP49PiMh0=";
  vendorHash = "sha256-j3BY6fEXCL82TDna80vjL25FDFLUhyMtmQW8d6GLQdk=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
