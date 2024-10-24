import ./generic.nix {
  version = "9.0.0";
  hash = "sha256-GzkuJ2aJ7I4/xDLLIrwcgXuInXoXzMWvQ7Z1mdGaOPw=";
  npmDepsHash = "sha256-UFUNOR+ks3hDmT7uVEToX+rMmlFL6gQqigAxl6RP37Q=";
  vendorHash = "sha256-j3BY6fEXCL82TDna80vjL25FDFLUhyMtmQW8d6GLQdk=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
