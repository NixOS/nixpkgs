import ./generic.nix {
  version = "9.0.0";
  rev = "0ae05e1000d2dd8354b932fcc19c8eda23647da6";
  hash = "sha256-BXVPB8DXkMkKv/5CFZsxx7xjBvA62Oogk+zC5brjXGY=";
  npmDepsHash = "sha256-UFUNOR+ks3hDmT7uVEToX+rMmlFL6gQqigAxl6RP37Q=";
  vendorHash = "sha256-j3BY6fEXCL82TDna80vjL25FDFLUhyMtmQW8d6GLQdk=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
