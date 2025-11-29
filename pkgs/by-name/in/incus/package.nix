import ./generic.nix {
  hash = "sha256-0zGLMWkEeJmSrmJvjmJ+d/FjE1btMwif6ugaHUBLD0A=";
  version = "6.19.0";
  vendorHash = "sha256-Dx/AsSvDL/cHS/nRV5invkxgBg4w8jvtZ20LK7tOW14=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
