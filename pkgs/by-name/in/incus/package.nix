import ./generic.nix {
  hash = "sha256-HhgAZ/MDNX6v1tBLv4sMHfFQMPoYkTaaWM8aLkl31Mg=";
  version = "6.15.0";
  vendorHash = "sha256-pCpOHFWyacJ3K1EyK2Pkezv0Ooj+sFQ3ZmtBmhZJYNE=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
