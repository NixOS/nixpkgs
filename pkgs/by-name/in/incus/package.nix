import ./generic.nix {
  hash = "sha256-TdJe/vnjSc5ZT5tgZQsQacCVfW5+TKd5cjQLOp8SuZg=";
  version = "6.19.1";
  vendorHash = "sha256-Dx/AsSvDL/cHS/nRV5invkxgBg4w8jvtZ20LK7tOW14=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
