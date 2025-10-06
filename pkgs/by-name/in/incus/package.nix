import ./generic.nix {
  hash = "sha256-QtsdKXgf995FzMxSHYz8LupECeRA2nriz9Bb3S0epKY=";
  version = "6.17.0";
  vendorHash = "sha256-5BQFoiutNuvFu+oA3ZpD8w8qtrf7l/B5b3eHwSEfzBU=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
