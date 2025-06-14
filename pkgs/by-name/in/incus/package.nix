import ./generic.nix {
  hash = "sha256-f02BBEZ9EqLWJNxJ+Qj8PtcgkRT2Dy/hwUA/1aAZXC8=";
  version = "6.13.0";
  vendorHash = "sha256-g71ORfg/BMucohBfPWwSbyLdmo5SpkStUKbszZFFaKQ=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
