import ./generic.nix {
  version = "8.0.1";
  hash = "sha256-0D2ntZVK4k5AwAMg4XnLyabnxAoHx9JjBoFAdkfrdAY=";
  npmDepsHash = "sha256-6AMaZadgcTvOBsIXJjZQB6Q1rkdn+R82pclXdVvtdWY=";
  vendorHash = "sha256-tNb0tCf+gjUmUqrjkzt7Wqqz21hW9WRh8CEdX8rv8Do=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
