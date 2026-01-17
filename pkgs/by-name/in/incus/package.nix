import ./generic.nix {
  hash = "sha256-nhf7defhiFBHsqfZ6y+NN3TuteII6t8zCvpTsPsO+EE=";
  version = "6.20.0";
  vendorHash = "sha256-jIOV6vIkptHEuZcD/aS386o2M2AQHTjHngBxFi2tESA=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
