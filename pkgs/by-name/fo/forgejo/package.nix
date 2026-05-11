import ./generic.nix {
  version = "15.0.1";
  hash = "sha256-40hyQ6MPskyty/LsMVczuDpbu2q3Syoj3c00HUS+pVE=";
  npmDepsHash = "sha256-xWbnSX11RkLjtJ62qG6rD+xQAOnUuI99r9uEHakkZPY=";
  vendorHash = "sha256-JUBAcRYgflrvoAK0OvaU/Xr6/BakgaUtYwtvBF9vyk0=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
