import ./generic.nix {
  version = "11.0.9";
  hash = "sha256-1jp0FT/T+j1CAPc99lTRSUd4R4YhgLMjZr4k3jW6ho8=";
  npmDepsHash = "sha256-Qs1aZxgjlsjdxfBpa4pOrwEfDfb/96L49uJd29Ysn/I=";
  vendorHash = "sha256-TVp4WxrGBlKVaPIbsj4EP/3pt5iseXLY7xIVum71ZXU=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
