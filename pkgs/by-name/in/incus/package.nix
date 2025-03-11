import ./generic.nix {
  hash = "sha256-uuaJoUrAZ1kSeO2xdXhfdI8Zy4zbA9r1pIhPMqzUios=";
  version = "6.10.1";
  vendorHash = "sha256-/8aBG8RiC03+oVI9lgPFwbi3b4juumziXL4WH0k/4PA=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
