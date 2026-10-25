import ./generic.nix {
  version = "16.0.6";
  hash = "sha256-629cbLUh+okT3SFHwHFQDPiOoao0hrTxOzdOKxYEd6Q=";
  npmDepsHash = "sha256-C/ht4Z3ivtm6nBNHUkNmKpLsnmnrpzW6rBq153LuITc=";
  vendorHash = "sha256-wOAbZ6eEwlavMIcTOmqPpdgLNcgylCX4MwxuI/35YZw=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
