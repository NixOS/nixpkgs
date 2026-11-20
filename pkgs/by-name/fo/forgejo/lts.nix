import ./generic.nix {
  version = "15.0.12";
  hash = "sha256-XWypBkRS4TbzT5pvXR5OPUdnx5JYJvUzzBBFCoe74iI=";
  npmDepsHash = "sha256-5SKoF4RUhKHfUbhdb6LLJCH7FHLmfM/OjOdSsCrGvGU=";
  vendorHash = "sha256-U6lkU2dI2/+8lrlGIU9T/E+HEl7VacpO1zUQdUuIIi8=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
