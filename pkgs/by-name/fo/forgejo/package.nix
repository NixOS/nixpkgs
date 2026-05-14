import ./generic.nix {
  version = "15.0.2";
  hash = "sha256-ba5jog6eXY4TTmBblhfVa2LSLPGE1/HPfslIb30b3kk=";
  npmDepsHash = "sha256-70w39jbMWpuAsbzBC9oFHaUMwshtFDeTSEOXDgFNPmE=";
  vendorHash = "sha256-I6bGvXBP2K3+Xx9E9DS/AyG6Ilqf/s8VjfBnCmLUHsk=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
