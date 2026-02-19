import ./generic.nix {
  hash = "sha256-zn4U44aGBQGjCyvziIPKqhR6RbQJTR0yF8GkyxGeSMc=";
  version = "6.21.0";
  vendorHash = "sha256-ECk3gB94B5vv9N2S7beU6B3jSsq1x8vXtcpXg/KBHYI=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
