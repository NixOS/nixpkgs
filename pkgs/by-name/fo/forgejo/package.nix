import ./generic.nix {
  version = "8.0.2";
  hash = "sha256-rjwZjwt0F9AhXgQ8CzOfsZ3acyBvzsDc/2LHRWieDzg=";
  npmDepsHash = "sha256-6AMaZadgcTvOBsIXJjZQB6Q1rkdn+R82pclXdVvtdWY=";
  vendorHash = "sha256-4l4kscwesW/cR8mZjE3G9HcVm0d1ukxbtBY6RXYRi8k=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
