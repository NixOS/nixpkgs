import ./generic.nix {
  hash = "sha256-DgPSH5t1Zx2X9T8dbpz54M5nXNcCJbdfcq9AEd8kmYo=";
  version = "6.0.6";
  vendorHash = "sha256-bVJwg9VaiSgfpKo+e2oMsYgmaKk42dktq0pahcfbjp0=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
