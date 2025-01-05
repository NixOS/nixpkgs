import ./generic.nix {
  version = "9.0.3";
  hash = "sha256-Ig4iz/ZoRj4lyod73GWY2oRV3E3tx3S4rNqQtsTonzQ=";
  npmDepsHash = "sha256-yDNlD1l5xuLkkp6LbOlWj9OYHO+WtiAeiu9oIoQLFL8=";
  vendorHash = "sha256-JLruZi8mXR1f+o9Olhbz44ieEXVGinUNmVi24VEYj28=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
