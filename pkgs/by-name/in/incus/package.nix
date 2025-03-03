import ./generic.nix {
  hash = "sha256-na+YkpjymfpXGf6Y27PzlQH/Ol2hE7z9y7vruClUIb4=";
  version = "6.10.0";
  vendorHash = "sha256-/8aBG8RiC03+oVI9lgPFwbi3b4juumziXL4WH0k/4PA=";
  patches = [
    ./20dff3230ea0a1d0a0e26a45c1a4e6c95fb3ada2.patch
    ./62b7ba1b1a28a9e87793af78db5589aef67dd6b9.patch
  ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
