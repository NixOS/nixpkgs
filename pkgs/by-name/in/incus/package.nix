import ./generic.nix {
  hash = "sha256-XJp0Loaj3FFygyiIkSaMl4T0KmkNt7xtyU4nz++6yHs=";
  version = "6.18.0";
  vendorHash = "sha256-ySNeO06x8FzCH29EHbO3/ASVNSXTviyeULFrVoQwxcw=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
