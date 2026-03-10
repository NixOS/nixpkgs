import ./generic.nix {
  hash = "sha256-KanD657VNxcf7xjFkEoQZJz3hB12KOuAAEInNZoQmcY=";
  version = "6.22.0";
  vendorHash = "sha256-9ksX6/atzRkPCXrMZj0q+sEV0RY9UJ1QgGmc4YWs2Uw=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
