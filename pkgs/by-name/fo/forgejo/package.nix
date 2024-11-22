import ./generic.nix {
  version = "9.0.2";
  hash = "sha256-ecPt1OQNAHzaGDEaYAcxplJq+gufb13y7vEV+dbV8C8=";
  npmDepsHash = "sha256-V7Ubhu3PlZyW0KCHMFqrQahSlWEh5856yMvt0iYlfz0=";
  vendorHash = "sha256-j3BY6fEXCL82TDna80vjL25FDFLUhyMtmQW8d6GLQdk=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
