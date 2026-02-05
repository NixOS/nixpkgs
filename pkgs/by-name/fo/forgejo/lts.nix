import ./generic.nix {
  version = "11.0.10";
  hash = "sha256-vATc7pBOejBfZKNj3WsQeFWr1xKpIB4ODv4TPRrwdg0=";
  npmDepsHash = "sha256-Qs1aZxgjlsjdxfBpa4pOrwEfDfb/96L49uJd29Ysn/I=";
  vendorHash = "sha256-TVp4WxrGBlKVaPIbsj4EP/3pt5iseXLY7xIVum71ZXU=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
